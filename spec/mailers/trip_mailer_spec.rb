require "rails_helper"

RSpec.describe TripMailer, type: :mailer do
  describe "trip_invite" do
    let(:mail) { TripMailer.trip_invite }

    it "renders the headers" do
      expect(mail.subject).to eq("Trip invite")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
