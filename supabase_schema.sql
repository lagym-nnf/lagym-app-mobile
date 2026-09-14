-- LA GYM App - Supabase Database Schema
-- Run this in Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- USERS & AUTH
-- =============================================

-- Profiles table (extends auth.users)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  date_of_birth DATE,
  weight DECIMAL(5,2),
  height DECIMAL(5,2),
  fitness_goals TEXT[] DEFAULT '{}',
  workout_location TEXT DEFAULT 'home' CHECK (workout_location IN ('gym', 'home', 'homeGym')),
  fitness_level TEXT DEFAULT 'beginner' CHECK (fitness_level IN ('beginner', 'intermediate', 'advanced')),
  subscription_tier TEXT DEFAULT 'free' CHECK (subscription_tier IN ('free', 'premium', 'premiumNutrition')),
  subscription_status TEXT DEFAULT 'trial' CHECK (subscription_status IN ('active', 'trial', 'expired', 'cancelled')),
  trial_start_date TIMESTAMPTZ,
  trial_end_date TIMESTAMPTZ,
  subscription_start_date TIMESTAMPTZ,
  subscription_end_date TIMESTAMPTZ,
  revenuecat_customer_id TEXT,
  onboarding_completed BOOLEAN DEFAULT FALSE,
  notifications_enabled BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Daily habits tracking
CREATE TABLE daily_habits (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  drank_water BOOLEAN DEFAULT FALSE,
  completed_steps BOOLEAN DEFAULT FALSE,
  water_amount INT,
  step_count INT,
  custom_habits JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, date)
);

-- =============================================
-- WORKOUTS & PROGRAMS
-- =============================================

-- Training categories
CREATE TABLE training_categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  thumbnail_url TEXT,
  display_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Coaches
CREATE TABLE coaches (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  type TEXT DEFAULT 'coach' CHECK (type IN ('coach', 'nutritionist', 'physiotherapist')),
  bio TEXT,
  avatar_url TEXT,
  specialties TEXT[] DEFAULT '{}',
  rating DECIMAL(2,1),
  total_sessions INT DEFAULT 0,
  price_per_session INT,
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Programs
CREATE TABLE programs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  type TEXT NOT NULL CHECK (type IN ('fixed', 'infinity')),
  category_id UUID REFERENCES training_categories(id),
  difficulty TEXT DEFAULT 'intermediate' CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  thumbnail_url TEXT,
  coach_id UUID REFERENCES coaches(id),
  duration_weeks INT,
  workouts_per_week INT,
  total_workouts INT,
  is_premium BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Exercises
CREATE TABLE exercises (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  thumbnail_url TEXT,
  video_url TEXT,
  mux_playback_id TEXT,
  target_muscles TEXT[] DEFAULT '{}',
  equipment TEXT[] DEFAULT '{}',
  instructions TEXT[] DEFAULT '{}',
  tips TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Workouts
CREATE TABLE workouts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  type TEXT NOT NULL CHECK (type IN ('setsReps', 'followAlong')),
  category_id UUID REFERENCES training_categories(id),
  difficulty TEXT DEFAULT 'intermediate',
  location TEXT DEFAULT 'home' CHECK (location IN ('gym', 'home', 'homeGym')),
  duration_minutes INT NOT NULL,
  calories_burned INT,
  thumbnail_url TEXT,
  video_url TEXT,
  mux_playback_id TEXT,
  coach_id UUID REFERENCES coaches(id),
  is_premium BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Workout exercises (sets/reps configuration)
CREATE TABLE workout_exercises (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workout_id UUID NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES exercises(id),
  sequence_order INT NOT NULL,
  sets INT,
  reps INT,
  duration_seconds INT,
  rest_seconds INT DEFAULT 60,
  notes TEXT
);

-- Program workouts (links programs to workouts)
CREATE TABLE program_workouts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  program_id UUID NOT NULL REFERENCES programs(id) ON DELETE CASCADE,
  workout_id UUID NOT NULL REFERENCES workouts(id),
  sequence_number INT NOT NULL, -- Day number for infinity programs
  week_number INT, -- For fixed programs
  day_of_week INT CHECK (day_of_week BETWEEN 1 AND 7)
);

-- User program enrollments
CREATE TABLE user_program_enrollments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  program_id UUID NOT NULL REFERENCES programs(id),
  current_sequence INT DEFAULT 1,
  enrolled_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  UNIQUE(user_id, program_id)
);

-- =============================================
-- USER PROGRESS
-- =============================================

-- Workout completions
CREATE TABLE workout_completions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  workout_id UUID NOT NULL REFERENCES workouts(id),
  completed_at TIMESTAMPTZ DEFAULT NOW(),
  duration_minutes INT,
  calories_burned INT,
  notes TEXT,
  exercise_data JSONB DEFAULT '{}'
);

-- Weight logs
CREATE TABLE weight_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  weight DECIMAL(5,2) NOT NULL,
  unit TEXT DEFAULT 'kg' CHECK (unit IN ('kg', 'lbs')),
  logged_at TIMESTAMPTZ DEFAULT NOW(),
  notes TEXT
);

-- Progress photos
CREATE TABLE progress_photos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  photo_url TEXT NOT NULL,
  taken_at TIMESTAMPTZ DEFAULT NOW(),
  notes TEXT,
  is_front BOOLEAN DEFAULT FALSE,
  is_side BOOLEAN DEFAULT FALSE,
  is_back BOOLEAN DEFAULT FALSE
);

-- Streaks
CREATE TABLE streaks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  streak_type TEXT NOT NULL,
  current_streak INT DEFAULT 0,
  longest_streak INT DEFAULT 0,
  last_activity_date DATE,
  UNIQUE(user_id, streak_type)
);

-- =============================================
-- CHALLENGES & REWARDS
-- =============================================

-- Challenges
CREATE TABLE challenges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  type TEXT NOT NULL CHECK (type IN ('daily', 'weekly', 'monthly')),
  thumbnail_url TEXT,
  target_count INT,
  target_minutes INT,
  start_date DATE,
  end_date DATE,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User challenges
CREATE TABLE user_challenges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  challenge_id UUID NOT NULL REFERENCES challenges(id),
  progress INT DEFAULT 0,
  completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMPTZ,
  UNIQUE(user_id, challenge_id)
);

-- Badges
CREATE TABLE badges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  icon_url TEXT,
  requirement TEXT,
  target_value INT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User badges
CREATE TABLE user_badges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  badge_id UUID NOT NULL REFERENCES badges(id),
  earned_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, badge_id)
);

-- =============================================
-- NUTRITION
-- =============================================

-- Recipes
CREATE TABLE recipes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL CHECK (category IN ('breakfast', 'lunch', 'dinner', 'snack', 'smoothie', 'dessert')),
  calories INT NOT NULL,
  prep_time_minutes INT,
  cook_time_minutes INT,
  servings INT DEFAULT 1,
  thumbnail_url TEXT,
  video_url TEXT,
  dietary_tags TEXT[] DEFAULT '{}',
  ingredients JSONB DEFAULT '[]',
  instructions TEXT[] DEFAULT '{}',
  protein INT,
  carbs INT,
  fat INT,
  fiber INT,
  is_premium BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Grocery lists
CREATE TABLE grocery_lists (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  name TEXT DEFAULT 'My Grocery List',
  items JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- User favorite recipes
CREATE TABLE user_favorite_recipes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  recipe_id UUID NOT NULL REFERENCES recipes(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, recipe_id)
);

-- =============================================
-- SERVICES & BOOKINGS
-- =============================================

-- Availability slots
CREATE TABLE availability_slots (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  coach_id UUID NOT NULL REFERENCES coaches(id) ON DELETE CASCADE,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  is_booked BOOLEAN DEFAULT FALSE
);

-- Bookings
CREATE TABLE bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  coach_id UUID NOT NULL REFERENCES coaches(id),
  slot_id UUID NOT NULL REFERENCES availability_slots(id),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled')),
  booking_date TIMESTAMPTZ DEFAULT NOW(),
  notes TEXT,
  is_paid BOOLEAN DEFAULT FALSE,
  stripe_payment_id TEXT
);

-- =============================================
-- CONTENT
-- =============================================

-- Motivational messages
CREATE TABLE motivational_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  message TEXT NOT NULL,
  author TEXT,
  display_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Chat messages (AI chatbot)
CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('user', 'assistant')),
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- ROW LEVEL SECURITY
-- =============================================

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_habits ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_program_enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE workout_completions ENABLE ROW LEVEL SECURITY;
ALTER TABLE weight_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE progress_photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE grocery_lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorite_recipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Daily habits policies
CREATE POLICY "Users can manage own habits" ON daily_habits FOR ALL USING (auth.uid() = user_id);

-- User program enrollments policies
CREATE POLICY "Users can manage own enrollments" ON user_program_enrollments FOR ALL USING (auth.uid() = user_id);

-- Workout completions policies
CREATE POLICY "Users can manage own completions" ON workout_completions FOR ALL USING (auth.uid() = user_id);

-- Weight logs policies
CREATE POLICY "Users can manage own weight logs" ON weight_logs FOR ALL USING (auth.uid() = user_id);

-- Progress photos policies
CREATE POLICY "Users can manage own photos" ON progress_photos FOR ALL USING (auth.uid() = user_id);

-- Streaks policies
CREATE POLICY "Users can manage own streaks" ON streaks FOR ALL USING (auth.uid() = user_id);

-- User challenges policies
CREATE POLICY "Users can manage own challenges" ON user_challenges FOR ALL USING (auth.uid() = user_id);

-- User badges policies
CREATE POLICY "Users can view own badges" ON user_badges FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "System can insert badges" ON user_badges FOR INSERT WITH CHECK (TRUE);

-- Grocery lists policies
CREATE POLICY "Users can manage own grocery lists" ON grocery_lists FOR ALL USING (auth.uid() = user_id);

-- User favorite recipes policies
CREATE POLICY "Users can manage own favorites" ON user_favorite_recipes FOR ALL USING (auth.uid() = user_id);

-- Bookings policies
CREATE POLICY "Users can manage own bookings" ON bookings FOR ALL USING (auth.uid() = user_id);

-- Chat messages policies
CREATE POLICY "Users can manage own messages" ON chat_messages FOR ALL USING (auth.uid() = user_id);

-- Public read access for content tables
CREATE POLICY "Public read access" ON training_categories FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "Public read access" ON coaches FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "Public read access" ON programs FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "Public read access" ON workouts FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "Public read access" ON exercises FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "Public read access" ON workout_exercises FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "Public read access" ON program_workouts FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "Public read access" ON challenges FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "Public read access" ON badges FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "Public read access" ON recipes FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "Public read access" ON motivational_messages FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "Public read access" ON availability_slots FOR SELECT TO authenticated USING (TRUE);

-- =============================================
-- FUNCTIONS & TRIGGERS
-- =============================================

-- Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER grocery_lists_updated_at
  BEFORE UPDATE ON grocery_lists
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Function to increment infinity program sequence
CREATE OR REPLACE FUNCTION increment_program_sequence(p_user_id UUID, p_program_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE user_program_enrollments
  SET current_sequence = current_sequence + 1
  WHERE user_id = p_user_id AND program_id = p_program_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to update streak
CREATE OR REPLACE FUNCTION update_user_streak(p_user_id UUID, p_streak_type TEXT)
RETURNS void AS $$
DECLARE
  v_last_date DATE;
  v_current_streak INT;
  v_longest_streak INT;
BEGIN
  SELECT last_activity_date, current_streak, longest_streak
  INTO v_last_date, v_current_streak, v_longest_streak
  FROM streaks
  WHERE user_id = p_user_id AND streak_type = p_streak_type;

  IF NOT FOUND THEN
    INSERT INTO streaks (user_id, streak_type, current_streak, longest_streak, last_activity_date)
    VALUES (p_user_id, p_streak_type, 1, 1, CURRENT_DATE);
  ELSIF v_last_date = CURRENT_DATE - 1 THEN
    UPDATE streaks
    SET current_streak = current_streak + 1,
        longest_streak = GREATEST(longest_streak, current_streak + 1),
        last_activity_date = CURRENT_DATE
    WHERE user_id = p_user_id AND streak_type = p_streak_type;
  ELSIF v_last_date < CURRENT_DATE - 1 THEN
    UPDATE streaks
    SET current_streak = 1,
        last_activity_date = CURRENT_DATE
    WHERE user_id = p_user_id AND streak_type = p_streak_type;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================
-- SEED DATA
-- =============================================

-- Insert training categories
INSERT INTO training_categories (name, description, display_order) VALUES
  ('Strength', 'Build muscle and increase strength', 1),
  ('Pilates', 'Core strength and flexibility', 2),
  ('Cardio', 'Boost endurance and burn calories', 3),
  ('Yoga', 'Flexibility and mindfulness', 4),
  ('HIIT', 'High intensity interval training', 5),
  ('Recovery', 'Stretching and mobility', 6),
  ('Barre', 'Ballet-inspired toning', 7),
  ('Pre & Post-Natal', 'Safe exercises for pregnancy', 8);

-- Insert sample badges
INSERT INTO badges (name, description, icon_url, requirement, target_value) VALUES
  ('First Workout', 'Complete your first workout', NULL, 'workouts', 1),
  ('7 Day Streak', 'Work out 7 days in a row', NULL, 'streak', 7),
  ('30 Day Streak', 'Work out 30 days in a row', NULL, 'streak', 30),
  ('100 Workouts', 'Complete 100 workouts', NULL, 'workouts', 100),
  ('Challenge Champion', 'Complete 10 challenges', NULL, 'challenges', 10);

-- Insert sample motivational messages
INSERT INTO motivational_messages (message, author) VALUES
  ('Your only limit is you.', 'LA GYM'),
  ('Strong is the new beautiful.', 'LA GYM'),
  ('Every workout counts.', 'LA GYM'),
  ('Progress, not perfection.', 'LA GYM'),
  ('You are stronger than you think.', 'LA GYM');
