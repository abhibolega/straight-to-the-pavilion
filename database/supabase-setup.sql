-- Straight to the Pavilion: online accounts (run once in Supabase > SQL Editor)
-- Usernames are unique across all devices. The table is locked down: the game can
-- only talk to it through the five functions below, so nobody can list the table.

create table if not exists public.players (
  username     text primary key check (username ~ '^[a-z0-9_]{3,16}$'),
  salt         text not null,
  hash         text not null,
  display_name text not null default '',
  stats        jsonb not null default '{}'::jsonb,
  created_at   timestamptz not null default now()
);

alter table public.players enable row level security;   -- no policies = no direct access

create or replace function public.sp_get_salt(p_username text)
returns text language sql security definer set search_path = public as $$
  select salt from public.players where username = lower(p_username)
$$;

create or replace function public.sp_register(p_username text, p_salt text, p_hash text, p_name text)
returns jsonb language plpgsql security definer set search_path = public as $$
declare v_name text := left(coalesce(nullif(p_name, ''), lower(p_username)), 14);
begin
  insert into public.players (username, salt, hash, display_name)
  values (lower(p_username), p_salt, p_hash, v_name);     -- duplicate username => error 23505
  return jsonb_build_object('display_name', v_name, 'stats', '{}'::jsonb);
end $$;

create or replace function public.sp_login(p_username text, p_hash text)
returns jsonb language sql security definer set search_path = public as $$
  select jsonb_build_object('display_name', display_name, 'stats', stats)
  from public.players where username = lower(p_username) and hash = p_hash
$$;

create or replace function public.sp_save(p_username text, p_hash text, p_name text, p_stats jsonb)
returns boolean language plpgsql security definer set search_path = public as $$
begin
  update public.players
     set display_name = left(coalesce(nullif(p_name, ''), username), 14), stats = coalesce(p_stats, '{}'::jsonb)
   where username = lower(p_username) and hash = p_hash;
  return found;
end $$;

revoke all on function public.sp_get_salt(text), public.sp_register(text,text,text,text),
  public.sp_login(text,text), public.sp_save(text,text,text,jsonb) from public;
grant execute on function public.sp_get_salt(text), public.sp_register(text,text,text,text),
  public.sp_login(text,text), public.sp_save(text,text,text,jsonb) to anon;
