-- LA GYM App - Supabase Database Schema v2
-- Additional tables for Admin App and Private Coaching
-- Run this AFTER the initial supabase_schema.sql

-- =============================================
-- SCHEMA ADDITIONS FOR ADMIN & PRIVATE COACHING
-- =============================================

-- Admin/Employee user roles for web app
CREATE TABLE admin_users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  full_name TEXT,
  avatar_url TEXT,
  role TEXT NOT NULL CHECK (role IN ('admin', 'coach', 'employee')),
  coach_id UUID REFERENCES coaches(id),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Private coaching client relationships
CREATE TABLE private_coaching_clients (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  coach_id UUID NOT NULL REFERENCES coaches(id) ON DELETE CASCADE,
  client_user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  status TEXT NOT NULL CHECK (status IN ('pending', 'active', 'paused', 'cancelled')),
  started_at TIMESTAMPTZ,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(coach_id, client_user_id)
);

-- Coaching requests from mobile users
CREATE TABLE coaching_requests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  coach_id UUID NOT NULL REFERENCES coaches(id) ON DELETE CASCADE,
  message TEXT,
  status TEXT NOT NULL CHECK (status IN ('pending', 'accepted', 'declined')),
  responded_at TIMESTAMPTZ,
  response_message TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Personalized training plans for private clients
CREATE TABLE training_plans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  coach_id UUID NOT NULL REFERENCES coaches(id) ON DELETE CASCADE,
  client_user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  start_date DATE NOT NULL,
  end_date DATE,
  duration_weeks INT,
  status TEXT NOT NULL CHECK (status IN ('draft', 'active', 'completed', 'archived')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Training plan workout assignments
CREATE TABLE training_plan_workouts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  training_plan_id UUID NOT NULL REFERENCES training_plans(id) ON DELETE CASCADE,
  workout_id UUID NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
  scheduled_date DATE NOT NULL,
  week_number INT,
  day_of_week INT CHECK (day_of_week BETWEEN 1 AND 7),
  coach_notes TEXT,
  is_completed BOOLEAN DEFAULT false,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Notifications
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  body TEXT,
  data JSONB,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- MODIFICATIONS TO EXISTING TABLES
-- =============================================

-- Add private coaching fields to coaches table
ALTER TABLE coaches ADD COLUMN IF NOT EXISTS is_private_coach BOOLEAN DEFAULT false;
ALTER TABLE coaches ADD COLUMN IF NOT EXISTS accepts_new_clients BOOLEAN DEFAULT true;
ALTER TABLE coaches ADD COLUMN IF NOT EXISTS private_session_price DECIMAL(10,2);
ALTER TABLE coaches ADD COLUMN IF NOT EXISTS title TEXT;

-- Add YouTube support to workouts
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS youtube_url TEXT;

-- Add coaching reference to profiles
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS private_coach_id UUID REFERENCES coaches(id);

-- =============================================
-- ROW LEVEL SECURITY FOR NEW TABLES
-- =============================================

-- Enable RLS
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE private_coaching_clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE coaching_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE training_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE training_plan_workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Admin users policies (only admins can manage)
CREATE POLICY "Admins can view admin_users" ON admin_users
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.user_id = auth.uid() AND au.role = 'admin'
    )
  );

CREATE POLICY "Admins can manage admin_users" ON admin_users
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.user_id = auth.uid() AND au.role = 'admin'
    )
  );

-- Self-lookup for admin users
CREATE POLICY "Users can view own admin record" ON admin_users
  FOR SELECT TO authenticated
  USING (user_id = auth.uid());

-- Private coaching clients policies
CREATE POLICY "Coaches can view own clients" ON private_coaching_clients
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.user_id = auth.uid()
      AND au.coach_id = private_coaching_clients.coach_id
    )
  );

CREATE POLICY "Coaches can manage own clients" ON private_coaching_clients
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.user_id = auth.uid()
      AND au.coach_id = private_coaching_clients.coach_id
    )
  );

CREATE POLICY "Users can view own coaching relationship" ON private_coaching_clients
  FOR SELECT TO authenticated
  USING (client_user_id = auth.uid());

-- Coaching requests policies
CREATE POLICY "Users can create coaching requests" ON coaching_requests
  FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can view own requests" ON coaching_requests
  FOR SELECT TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Coaches can view requests to them" ON coaching_requests
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.user_id = auth.uid()
      AND au.coach_id = coaching_requests.coach_id
    )
  );

CREATE POLICY "Coaches can update requests to them" ON coaching_requests
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.user_id = auth.uid()
      AND au.coach_id = coaching_requests.coach_id
    )
  );

-- Training plans policies
CREATE POLICY "Coaches can manage own training plans" ON training_plans
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.user_id = auth.uid()
      AND au.coach_id = training_plans.coach_id
    )
  );

CREATE POLICY "Clients can view own training plans" ON training_plans
  FOR SELECT TO authenticated
  USING (client_user_id = auth.uid());

-- Training plan workouts policies
CREATE POLICY "Coaches can manage training plan workouts" ON training_plan_workouts
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM training_plans tp
      JOIN admin_users au ON au.coach_id = tp.coach_id
      WHERE tp.id = training_plan_workouts.training_plan_id
      AND au.user_id = auth.uid()
    )
  );

CREATE POLICY "Clients can view own training plan workouts" ON training_plan_workouts
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM training_plans tp
      WHERE tp.id = training_plan_workouts.training_plan_id
      AND tp.client_user_id = auth.uid()
    )
  );

CREATE POLICY "Clients can update completion status" ON training_plan_workouts
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM training_plans tp
      WHERE tp.id = training_plan_workouts.training_plan_id
      AND tp.client_user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM training_plans tp
      WHERE tp.id = training_plan_workouts.training_plan_id
      AND tp.client_user_id = auth.uid()
    )
  );

-- Notifications policies
CREATE POLICY "Users can view own notifications" ON notifications
  FOR SELECT TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Users can update own notifications" ON notifications
  FOR UPDATE TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "System can insert notifications" ON notifications
  FOR INSERT TO authenticated
  WITH CHECK (true);

-- =============================================
-- ADDITIONAL ADMIN POLICIES FOR CONTENT MANAGEMENT
-- =============================================

-- Allow admins and coaches to manage workouts
CREATE POLICY "Admins can manage workouts" ON workouts
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.user_id = auth.uid()
      AND au.role IN ('admin', 'coach')
    )
  );

-- Allow admins to manage exercises
CREATE POLICY "Admins can manage exercises" ON exercises
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.user_id = auth.uid()
      AND au.role IN ('admin', 'coach')
    )
  );

-- Allow admins to manage programs
CREATE POLICY "Admins can manage programs" ON programs
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.user_id = auth.uid()
      AND au.role IN ('admin', 'coach')
    )
  );

-- Allow admins and employees to manage program workouts (for daily workout assignment)
CREATE POLICY "Admins can manage program_workouts" ON program_workouts
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.user_id = auth.uid()
      AND au.role IN ('admin', 'coach', 'employee')
    )
  );

-- Allow admins to manage workout exercises
CREATE POLICY "Admins can manage workout_exercises" ON workout_exercises
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.user_id = auth.uid()
      AND au.role IN ('admin', 'coach')
    )
  );

-- Allow admins to manage coaches
CREATE POLICY "Admins can manage coaches" ON coaches
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.user_id = auth.uid()
      AND au.role = 'admin'
    )
  );

-- =============================================
-- TRIGGERS FOR NEW TABLES
-- =============================================

CREATE TRIGGER admin_users_updated_at
  BEFORE UPDATE ON admin_users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER training_plans_updated_at
  BEFORE UPDATE ON training_plans
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- =============================================
-- SEED DATA: FOUNDER COACHES
-- =============================================

INSERT INTO coaches (name, title, bio, avatar_url, specialties, is_private_coach, accepts_new_clients)
VALUES
  ('Iva Opačak', 'Head Coach & Co-Founder',
   'Certified personal trainer with 8+ years experience. Specializes in building lean muscle and functional strength. Passionate about empowering women through fitness.',
   '/images/coaches/iva.jpg', ARRAY['Strength', 'Conditioning'], true, true),
  ('Mija Lonjak', 'Fitness Director & Co-Founder',
   'Expert in high-intensity training and body transformation. Helped hundreds of women achieve their fitness goals through personalized programs.',
   '/images/coaches/mija.jpg', ARRAY['HIIT', 'Weight Loss'], true, true),
  ('Lara Arači', 'Wellness Coach & Co-Founder',
   'Holistic approach to fitness combining pilates, mobility work, and mindful movement. Focuses on long-term sustainable fitness habits.',
   '/images/coaches/lara.jpg', ARRAY['Pilates', 'Recovery'], true, true);

-- =============================================
-- HELPER FUNCTIONS
-- =============================================

-- Function to check if user is admin
CREATE OR REPLACE FUNCTION is_admin(p_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM admin_users
    WHERE user_id = p_user_id AND role = 'admin' AND is_active = true
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check user's admin role
CREATE OR REPLACE FUNCTION get_admin_role(p_user_id UUID)
RETURNS TEXT AS $$
DECLARE
  v_role TEXT;
BEGIN
  SELECT role INTO v_role
  FROM admin_users
  WHERE user_id = p_user_id AND is_active = true;
  RETURN v_role;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get coach's clients count
CREATE OR REPLACE FUNCTION get_coach_client_count(p_coach_id UUID)
RETURNS INT AS $$
DECLARE
  v_count INT;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM private_coaching_clients
  WHERE coach_id = p_coach_id AND status = 'active';
  RETURN v_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to create notification
CREATE OR REPLACE FUNCTION create_notification(
  p_user_id UUID,
  p_type TEXT,
  p_title TEXT,
  p_body TEXT DEFAULT NULL,
  p_data JSONB DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  v_id UUID;
BEGIN
  INSERT INTO notifications (user_id, type, title, body, data)
  VALUES (p_user_id, p_type, p_title, p_body, p_data)
  RETURNING id INTO v_id;
  RETURN v_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
