# Bulawan Panaderya: shared photo and text storage (Supabase)

After this setup, every photo, text and price you edit as admin is saved online, so all visitors and all browsers see the same website.

You need a free Supabase account and about 10 minutes. You only do this once.

## 1. Create the project
1. Go to https://supabase.com and sign in, then click **New project**.
2. Pick any name (for example `bulawan`), set a database password (save it somewhere), choose the closest region, and click **Create new project**. Wait until it finishes.

## 2. Create the admin user
1. Left menu: **Authentication > Users > Add user > Create new user**.
2. Email: your own email address (write it down, this is `ADMIN_EMAIL`).
3. Password: `Bulawan@Panaderya!` (this is the admin password you type on the website).
4. Tick **Auto Confirm User**, then click **Create user**.
5. Left menu: **Authentication > Sign In / Providers** (or **Settings**) and turn **OFF** "Allow new users to sign up". This stops strangers from creating accounts.

## 3. Create the table, the image bucket and the security rules
1. Left menu: **SQL Editor > New query**.
2. Open `supabase-setup.sql`, find `YOUR-ADMIN-EMAIL` and replace it with the same email from step 2 (keep it inside the quotes, use lowercase).
3. Paste the whole file into the query box and click **Run**. You should see "Success".

## 4. Put your keys into the website
1. Left menu: **Project Settings > API** (or **Connect**).
2. Copy the **Project URL** and the **anon public** key. (Never use the `service_role` key on a website.)
3. Open `index.html` in a text editor and find the block at the top of the `<script>` that says `SUPABASE SETTINGS`:

```js
const SUPABASE_URL      = 'https://YOUR-PROJECT-REF.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR-ANON-PUBLIC-KEY';
const ADMIN_EMAIL       = 'YOUR-ADMIN-EMAIL';
```

4. Replace the three values with yours and save.

## 5. Try it
1. Open `index.html`, click **More > Admin**, type the admin password.
2. Change a price, then hover a photo, click **Change photo**, crop it and press **Save / Update photo**.
3. Open the website in another browser (or a private window). The new price and photo should appear there too.

## Notes
- Visitors can only read. Only the admin email, signed in with the password, can change anything, and this is enforced by Supabase, not just by the page.
- The admin password is stored in Supabase, not in the website code. To change it: Authentication > Users > your user > Send password recovery, or reset it there.
- Photos live in the `bulawan-images` storage bucket. When you replace or remove a photo, the old file is deleted.
- Free Supabase projects pause after a week of no activity. Visit the Supabase dashboard and click Restore if that happens.
- Edits you made before this update were saved only in one browser and are not carried over.
