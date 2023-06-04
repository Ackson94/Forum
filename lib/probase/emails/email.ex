defmodule Probase.Emails.Email do
  import Bamboo.Email
  # alias Bamboo.Attachment
  use Bamboo.Phoenix, view: ProbaseWeb.EmailView
  alias  Probase.Emails.Mailer




  # def send_email_notification(attr) do
  #   Notifications.list_tbl_email_logs()
  #   |> Task.async_stream(&(email_alert(&1.email, attr) |> Mailer.deliver_now()),
  #     max_concurrency: 10,
  #     timeout: 30_000
  #   )
  #   |> Stream.run()
  # end  Prolegals.Emails.Email.password("coilardium")

  def password_alert(email, password) do
    password(email, password) |> Mailer.deliver_later()
  end

  def confirm_password_reset(token, email) do
    confirmation_token(token, email) |> Mailer.deliver_later()
  end

  def password(email, pwd) do

  end

  def confirmation_token(token, email) do

  end

  def re_assign_task(task_status, task, email, duration ) do

  end



  def sendss_alert(ticket_no, issue, urgency, bus_name, platiform, participant) do

  end




  def send_alerts( rep_name, ticket_no,  bus_name, issue,  platiform, urgency ) do

  end
  def send_alert(rep_name, ticket_no, bus_name, issue, platiform, urgency) do

   end

   def send_admin(rep_name, ticket_no, bus_name, issue, platiform, urgency, participant) do

   end

  def send_alert_2(issue, urgency, bus_name, platiform) do

  end
  ###########################################Developer Email######################################


  def send_alert_dev( developer, ticket_no, bus_name, issue, platiform) do

   end


  def send_dev( developer, ticket_no, bus_name, issue, platiform) do

  end


  #################################################################################
  def dev_client(developer, rep_name, issue_status, bus_name, issue, platiform, urgency) do

  end


    #################################################################################
  def client_to_probase( ticket_no, issue, urgency, bus_name, platiform,issue_status, rep_name) do

  end

  def dev_to_client( ticket_no, issue, urgency, platiform,issue_status, rep_name) do

  end




  def appointment(name, comment, appoint_date, time, email) do

  end

  def send_feedback(_name, comment, appoint_date, time, status, clients_email, reason) do

  end
  # Probase.Emails.Email.acc_creation("reaganchita@gmail", "password")

  def acc_creation(email, password) do

  end

  def project_task_creation(email, task) do

  end

  def update_acc_creation(email, password) do

  end

  def project_attachment(email, prjct_name, status) do

  end


  def meeting_to_members_of_staff(email, first_name, last_name, date_time, agenda) do

  end



  def task_assign_members(email, first_name, last_name, task_name, description_name) do

  end



  def password_resset(email, password) do

  end


end
