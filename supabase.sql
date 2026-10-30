-- Run in Supabase SQL Editor. Each authenticated user sees only their own workspace.
create table if not exists public.workspaces (
 user_id uuid primary key references auth.users(id) on delete cascade,
 data jsonb not null default '{"logs":[],"meetings":[],"tasks":[]}'::jsonb,
 updated_at timestamptz not null default now()
);
alter table public.workspaces enable row level security;
create policy "read own workspace" on public.workspaces for select to authenticated using ((select auth.uid()) = user_id);
create policy "insert own workspace" on public.workspaces for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "update own workspace" on public.workspaces for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
