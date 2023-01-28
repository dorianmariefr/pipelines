require "rails_helper"

RSpec.feature "pipeline form", type: :feature do
  it "registers the user, signs in the user and creates the pipeline" do
    name = "Dorian Marié"
    email = "dorian@dorianmarie.fr"
    password = SecureRandom.hex
    pipeline_name = SecureRandom.hex

    visit "/"
    click_on "New pipeline"

    fill_in "Your name", with: name
    fill_in "Your email", with: email
    fill_in "Your password", with: password
    fill_in "Name of the pipeline", with: pipeline_name

    click_on "Create pipeline"
    expect(page).to have_content(pipeline_name)
    click_on "Open menu"
    click_on "Account"
    expect(page).to have_content(email)
  end

  it "saves the password, the email and the name of the pipeline" do
    email = "dorian@dorianmarie.fr"
    password = SecureRandom.hex
    pipeline_name = SecureRandom.hex

    visit "/"
    click_on "New pipeline"

    fill_in "Your email", with: email
    fill_in "Your password", with: password
    fill_in "Name of the pipeline", with: pipeline_name

    click_on "Create pipeline"
    expect(page).to have_field("Your email", with: email)
    expect(page).to have_field("Your password", with: password)
  end

  it "saves the name" do
    name = "Dorian Marié"

    visit "/"
    click_on "New pipeline"

    fill_in "Your name", with: name
    click_on "Create pipeline"
    expect(page).to have_field("Your name", with: name)
  end

  it "logs in the user and creates the pipeline" do
    name = "Dorian Marié"
    email = "dorian@dorianmarie.fr"
    password = SecureRandom.hex
    pipeline_name = SecureRandom.hex
    user = User.create!(name: name, password: password)
    user.emails.create!(email: email)

    visit "/"
    click_on "Log in"
    within ".test-email-login" do
      fill_in "Email", with: email
      fill_in "Password", with: password
      click_on "Log in"
    end

    expect(page).to have_content("You are now logged in")

    within "header" do
      click_on "New pipeline"
    end

    fill_in "Name of the pipeline", with: pipeline_name
    click_on "Create pipeline"
    expect(page).to have_content(pipeline_name)
    click_on "Open menu"
    click_on "Account"
    expect(page).to have_content(email)
  end
end
