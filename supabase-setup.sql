-- Bulawan Panaderya: one-time database setup for Supabase.
-- 1) In Supabase open  SQL Editor > New query
-- 2) Replace YOUR-ADMIN-EMAIL below (it appears once) with the SAME email you use for the admin user, in lowercase
-- 3) Paste everything and press Run

-- Only this email is allowed to change the website.
create or replace function public.is_bulawan_admin()
returns boolean
language sql
stable
as $$
  select coalesce(auth.jwt() ->> 'email', '') = lower('runlocoph@gmail.com');
$$;

-- Table that holds every edited text, price and photo link.
create table if not exists public.site_content (
  key        text primary key,
  value      text not null,
  updated_at timestamptz not null default now()
);

alter table public.site_content enable row level security;

drop policy if exists "anyone can read content" on public.site_content;
create policy "anyone can read content"
  on public.site_content for select
  using (true);

drop policy if exists "admin can change content" on public.site_content;
create policy "admin can change content"
  on public.site_content for all
  to authenticated
  using (public.is_bulawan_admin())
  with check (public.is_bulawan_admin());

-- Public bucket that holds the uploaded photos.
insert into storage.buckets (id, name, public)
values ('bulawan-images', 'bulawan-images', true)
on conflict (id) do update set public = true;

drop policy if exists "anyone can view images" on storage.objects;
create policy "anyone can view images"
  on storage.objects for select
  using (bucket_id = 'bulawan-images');

drop policy if exists "admin can add images" on storage.objects;
create policy "admin can add images"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'bulawan-images' and public.is_bulawan_admin());

drop policy if exists "admin can update images" on storage.objects;
create policy "admin can update images"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'bulawan-images' and public.is_bulawan_admin());

drop policy if exists "admin can delete images" on storage.objects;
create policy "admin can delete images"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'bulawan-images' and public.is_bulawan_admin());
