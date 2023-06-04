Probase.Accounts.create_user_accounts(%{
  first_name: "Ackson",
  last_name: "Mutuma",
  email: "acksonicmutuma@gmail.com",
  company_name: "ZICB",
  phone_no: "0970186732",
  password: "123456",
  user_type: 1,
  status: 1,
  user_role: "dev",
  inserted_at: NaiveDateTime.utc_now(),
  updated_at: NaiveDateTime.utc_now()
})
