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
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("#{email}")
    |> put_html_layout({ProbaseWeb.LayoutView, "email.html"})
    |> subject("Tracter Password")
    |> assign(:pwd, pwd)
    |> render("notifications.html")
  end

  def confirmation_token(token, email) do
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("#{email}")

    |> put_html_layout({ProbaseWeb.LayoutView, "email.html"})
    |> subject("Tracker Password Reset")
    |> assign(:token, token)
    |> text_body(
      """
      Password Reset.

      """)
  end
  def re_assign_task(task_status, task, email, duration ) do
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("#{email}")
    |> subject("Probase Smart Management")
    |> text_body(
      """
      You have been assigned Task from Project Plan .
      Task Code: #{task_status}
      Task:  #{task}
      Duration:  #{duration} days


      """
    )
    |> Mailer.deliver_later()
  end



  def sendss_alert(ticket_no, issue, urgency, bus_name, platiform, participant) do
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("#{participant}")
    |> subject("Probase Issue Tracker")
    |> text_body(
      """
      An Issue has been logged in by a client.
      Ticket Number: #{ticket_no}
      Issue:  #{issue}
      Description:  #{urgency}
      Name of Client: #{bus_name}
      Platform giving issues:  #{platiform}

      """
    )
    |> Mailer.deliver_later()
  end




  def send_alerts( rep_name, ticket_no,  bus_name, issue,  platiform, urgency ) do
    new_email()
    |> from("#{rep_name}")
    |> to("Probase@probasegroup.com")
    |> subject("Probase Issue Tracker")
    |> text_body(
      """
      An Issue has been logged in by a client.
      Ticket Number: #{ticket_no}
      Name of Client: #{bus_name}
      Issue:  #{issue}
      Platform giving issues :  #{platiform}
      Description :  #{urgency}

      """
    )
    |> Mailer.deliver_later()
  end
  def send_alert(rep_name, ticket_no, bus_name, issue, platiform, urgency) do
    new_email()
    |> from("#{rep_name}")
    |> to("Probase@probasegroup.com")
    |> subject("Probase Issue Tracker")
    |> text_body(
      """
        An Issue has been escalated by front officer.
        Ticket Number: #{ticket_no}
        Name of Client: #{bus_name}
        Issue:  #{issue}
        Platform giving issues :  #{platiform}
        Description :  #{urgency}
      """
    )
    |> Mailer.deliver_later()
   end

   def send_admin(rep_name, ticket_no, bus_name, issue, platiform, urgency, participant) do
    new_email()
    |> from("#{rep_name}")
    |> to("#{participant}")
    |> subject("Probase Issue Tracker")
    |> text_body(
      """
        An Issue has been escalated by front officer Log in to assign an issue.
        Ticket Number: #{ticket_no}
        Name of Client: #{bus_name}
        Issue:  #{issue}
        Platform giving issues :  #{platiform}
        Description :  #{urgency}
        URL :  https://tracker.ops.probasegroup.com
      """
    )
    |> Mailer.deliver_later()
   end

  def send_alert_2(issue, urgency, bus_name, platiform) do
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("reaganchita@gmail.com")
    |> subject("Probase Issue Tracker")
    |> text_body(
      """

      An Issue has been logged in by a client.
       Name of Client : #{bus_name}
       Issue:  #{issue}
       Platform giving issues :  #{platiform}
       Description :  #{urgency}

      """
    )
    |> Mailer.deliver_later()
  end
  ###########################################Developer Email######################################


  def send_alert_dev( developer, ticket_no, bus_name, issue, platiform) do
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("#{developer}")
    |> subject("Probase Issue Tracker")
    |> text_body(
      """
       An Issue has been assigned to you.

       Ticket Number: #{ticket_no}
       Name of Client: #{bus_name}
       Issue: #{issue}
       Platform giving issues: #{platiform}

      """
    )
    |> Mailer.deliver_later()
   end


  def send_dev( developer, ticket_no, bus_name, issue, platiform) do
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("#{developer}")
    |> subject("Probase Issue Tracker")
    |> text_body(
      """
       An Issue has been assigned to you.
       Ticket Number: #{ticket_no}
       Name of Client: #{bus_name}
       Issue: #{issue}
       Platform giving issues: #{platiform}
      """
    )
    |> Mailer.deliver_later()
  end


  #################################################################################
  def dev_client(developer, rep_name, issue_status, bus_name, issue, platiform, urgency) do
    new_email()
    |> from("#{developer}")
    |> to("#{rep_name}")
    |> subject("Probase Issue Tracker")
    |> text_body(
      """
       Dear Client the Issue you raised Status is #{issue_status}.
       Name of Cilent : #{bus_name}
       Issue:  #{issue}
       Platform giving issues :  #{platiform}
       Description :  #{urgency}
      """
    )
    |> Mailer.deliver_later()
  end


    #################################################################################
  def client_to_probase( ticket_no, issue, urgency, bus_name, platiform,issue_status, rep_name) do
    new_email()
    |> from("#{rep_name}")
    |> to("Probase@probasegroup.com")
    |> subject("Probase Issue Tracker")
    |> text_body(
      """
       Probase Support team the Issue you requested for confirmation Status is #{issue_status}.
       Ticket Number: #{ticket_no}
       Name of Client : #{bus_name}
       Issue:  #{issue}
       Platform giving issues :  #{platiform}
       Description :  #{urgency}
      """
    )
    |> Mailer.deliver_later()
  end

  def dev_to_client( ticket_no, issue, urgency, platiform,issue_status, rep_name) do
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("#{rep_name}")
    |> subject("Probase Issue Tracker")
    |> text_body(
      """
       Dear Client the issue you raised Status is #{issue_status}.
       Ticket Number: #{ticket_no}
       Issue:  #{issue}
       Platform giving issues :  #{platiform}
       Description :  #{urgency}
      """
    )
    |> Mailer.deliver_later()
  end




  def appointment(name, comment, appoint_date, time, email) do
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("#{email}")
    |> subject("Appointment")
    |> text_body(
      """
      An appointment has been scheduled by a client.
      Name of Client : #{name}
      Purpose :  #{comment}
      Date  of Appointment:  #{appoint_date}
      Time of Appointment:  #{time}
      """
    )
    |> Mailer.deliver_later()
  end

  def send_feedback(_name, comment, appoint_date, time, status, clients_email, reason) do
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("#{clients_email}")
    |> subject("Appointment")
    |> text_body(
      """
      The appointment you scheduled has been:  #{status}

      Purpose :  #{comment}
      Date  of Appointment:  #{appoint_date}
      Time of Appointment:  #{time}
      Feedback : #{reason}
      """
    )
    |> Mailer.deliver_later()
  end
  # Probase.Emails.Email.acc_creation("reaganchita@gmail", "password")

  def acc_creation(email, password) do
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("#{email}")
    |> subject("Probase Issue Tracker Accounts")
    |> text_body(
      """
      Your Probase Account has been created Successfully:
      Use the following Credentials to login your Account

      User Name :  #{email}
      Password : #{password}
      link :  https://tracker.ops.probasegroup.com
      """
    )
    |> Mailer.deliver_later()
  end

  def project_task_creation(email, task) do
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("#{email}")
    |> subject("Task Assignment")
    |> text_body(
      """
      You been assigned a new task see the details below.


      Task: #{task}



      """
    )
    |> Mailer.deliver_later()
  end

  def update_acc_creation(email, password) do
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("#{email}")
    |> subject("Probase Issue Tracker Accounts")
    |> text_body(
      """
      Your Probase Account has been updated Successfully:
      Use the following Credentials to login your Account

      User Name :  #{email}
      Password : #{password}
      link :  https://tracker.ops.probasegroup.com
      """
    )
    |> Mailer.deliver_later()
  end

  def project_attachment(email, prjct_name, status) do
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("#{email}")
    |> subject("Probase Smart Manangement")
    |> text_body(
      """
        You have been attached to a new Project, Project Name #{prjct_name},Role #{status}
      """
    )
    |> Mailer.deliver_later()
  end


  def meeting_to_members_of_staff(email, first_name, last_name, date_time, agenda) do
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("#{email}")
    |> subject("Probase Smart Manangement")
    |> text_body(
      """
       Dear #{first_name} #{last_name}, You have been added to attend a meeting on #{date_time}. The agenda of the meeting #{agenda}.
      """
    )
    |> Mailer.deliver_later()
  end



  def task_assign_members(email, first_name, last_name, task_name, description_name) do
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("#{email}")
    |> subject("Probase Smart Manangement")
    |> text_body(
      """
       Dear #{first_name} #{last_name}, You have been assigned to a task #{task_name} and the description of the task #{description_name}.
      """
    )
    |> Mailer.deliver_later()
  end



  def password_resset(email, password) do
    new_email()
    |> from("Probase@probasegroup.com")
    |> to("#{email}")
    |> subject("Probase Issue Tracker Accounts")
    |> text_body(
      """
      Your Passwowrd has been resset succesfully:
      Use the following Credentials to login your Account

      User Name :  #{email}
      Password : #{password}
      link : " https://tracker.ops.probasegroup.com"
      """
    )
    |> Mailer.deliver_later()
  end


end
