-- Public bucket: objects are readable via public URL without a policy.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'uploads',
  'uploads',
  true,
  5242880, -- 5 MiB
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do nothing;

-- Demo app has no auth: allow anon/authenticated uploads (INSERT only) into this bucket.
create policy "uploads_insert_anon"
on storage.objects
for insert
to anon, authenticated
with check (bucket_id = 'uploads');
