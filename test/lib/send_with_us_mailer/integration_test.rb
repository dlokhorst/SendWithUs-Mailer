require_relative '../../test_helper'

describe SendWithUsMailer do
  describe "minimum requirements" do
    class ExampleMailer < SendWithUsMailer::Base
      def send_an_email
        mail email_id: '4bBEddKbhKBu5xsU2p58KX', to: 'dave@example.com'
      end
    end

    it "sets the email_id" do
      mail = ExampleMailer.send_an_email
      mail.email_id.must_equal '4bBEddKbhKBu5xsU2p58KX'
    end

    it "sets the recipient" do
      mail = ExampleMailer.send_an_email
      mail.to[:address].must_equal 'dave@example.com'
    end
  end

  describe "more mail options" do
    class MoreOptionsMailer < SendWithUsMailer::Base
      def example_email
        mail email_id: 'a4bBEddKbhKBu5xsU2p58KX',
             to: 'adave@example.com',
             from: 'asender@company.com',
             reply_to: 'ano-reply@company.com'
      end
    end

    it "sets the sender" do
      mail = MoreOptionsMailer.example_email
      mail.from[:address].must_equal 'asender@company.com'
    end

    it "sets the reply-to address" do
      mail = MoreOptionsMailer.example_email
      mail.from[:reply_to].must_equal 'ano-reply@company.com'
    end
  end

  describe "using default to set a parameter" do
    class MailerWithDefault < SendWithUsMailer::Base
      default email_id: 'def-4bBEddKbhKBu5xsU2p58KX'

      def send_an_email
        mail to: 'def-dave@example.com'
      end
    end

    it "sets the email_id" do
      mail = MailerWithDefault.send_an_email
      mail.email_id.must_equal 'def-4bBEddKbhKBu5xsU2p58KX'
    end

    it "sets the recipient" do
      mail = MailerWithDefault.send_an_email
      mail.to[:address].must_equal 'def-dave@example.com'
    end
  end

  describe "all parameters can be set by default" do
    class AllDefaultMailer < SendWithUsMailer::Base
      default email_id: 'all4bBEddKbhKBu5xsU2p58KX',
           to: 'alldave@example.com',
           from: 'allsender@company.com',
           reply_to: 'allno-reply@company.com'

      def send_default_email
        mail
      end
    end

    it "sets the email_id" do
      mail = AllDefaultMailer.send_default_email
      mail.email_id.must_equal 'all4bBEddKbhKBu5xsU2p58KX'
    end

    it "sets the recipient" do
      mail = AllDefaultMailer.send_default_email
      mail.to[:address].must_equal 'alldave@example.com'
    end
  end

  describe "using #assign" do
    User = Struct.new(:first_name, :last_name, :email)

    class MailerWithAssign < SendWithUsMailer::Base
      default email_id: '4bBEddKbhKBu5xsU2p58KX'

      def team_notification(user)
        assign :team, "The Winners"
        assign :user, {first_name: user.first_name, last_name: user.last_name}
        mail to: user.email
      end
    end

    it "creates the nested email_data hash" do
      mail = MailerWithAssign.team_notification(User.new("Dave","Lokhorst","dave@example.com"))
      mail.email_data.must_equal({
        team: "The Winners",
        user: {first_name: "Dave", last_name: "Lokhorst"}
      })
    end
  end
end