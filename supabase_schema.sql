-- ============================================
-- Mihrab - Supabase Database Schema
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- 1. Devices Table
-- ============================================
CREATE TABLE devices (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  token TEXT UNIQUE NOT NULL,
  name TEXT,
  display_mode TEXT NOT NULL DEFAULT 'prayer_times',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_seen_at TIMESTAMPTZ
);

-- Index for fast token lookup
CREATE INDEX idx_devices_token ON devices(token);

-- ============================================
-- 2. Device Settings Table
-- ============================================
CREATE TABLE device_settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  device_id UUID UNIQUE NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  latitude DOUBLE PRECISION NOT NULL DEFAULT 0,
  longitude DOUBLE PRECISION NOT NULL DEFAULT 0,
  city TEXT NOT NULL DEFAULT '',
  country TEXT NOT NULL DEFAULT '',
  calculation_method TEXT NOT NULL DEFAULT 'umm_al_qura',
  madhab INTEGER NOT NULL DEFAULT 0,
  high_latitude_rule INTEGER NOT NULL DEFAULT 0,
  adjustments JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for device_id lookup
CREATE INDEX idx_device_settings_device_id ON device_settings(device_id);

-- Auto-update updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER device_settings_updated_at
  BEFORE UPDATE ON device_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- ============================================
-- 3. Row Level Security (RLS)
-- ============================================

-- Enable RLS
ALTER TABLE devices ENABLE ROW LEVEL SECURITY;
ALTER TABLE device_settings ENABLE ROW LEVEL SECURITY;

-- Allow anonymous access (TV devices use anon key)
-- Devices: anyone can insert (register), select by token, update their own
CREATE POLICY "Anyone can register a device"
  ON devices FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Anyone can read devices by token"
  ON devices FOR SELECT
  USING (true);

CREATE POLICY "Anyone can update their device"
  ON devices FOR UPDATE
  USING (true);

CREATE POLICY "Anyone can delete their device"
  ON devices FOR DELETE
  USING (true);

-- Device settings: full access (controlled by app logic)
CREATE POLICY "Anyone can read device settings"
  ON device_settings FOR SELECT
  USING (true);

CREATE POLICY "Anyone can insert device settings"
  ON device_settings FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Anyone can update device settings"
  ON device_settings FOR UPDATE
  USING (true);

-- ============================================
-- 4. Realtime
-- ============================================
-- Enable realtime on device_settings so TV receives live updates
ALTER PUBLICATION supabase_realtime ADD TABLE device_settings;

-- ============================================
-- 5. Migrations
-- ============================================

-- Add hadith rotation interval (minutes) to device_settings
ALTER TABLE device_settings ADD COLUMN IF NOT EXISTS hadith_interval INTEGER NOT NULL DEFAULT 15;
ALTER PUBLICATION supabase_realtime ADD TABLE devices;

-- ============================================
-- 5. Helper: Create device with settings
-- ============================================
CREATE OR REPLACE FUNCTION register_device(p_token TEXT)
RETURNS UUID AS $$
DECLARE
  v_device_id UUID;
BEGIN
  INSERT INTO devices (token)
  VALUES (p_token)
  RETURNING id INTO v_device_id;

  INSERT INTO device_settings (device_id)
  VALUES (v_device_id);

  RETURN v_device_id;
END;
$$ LANGUAGE plpgsql;
