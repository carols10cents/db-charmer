require 'spec_helper'

describe "With a dynamic database.yml that uses ERB" do
  before do
    `cp -f config/dynamic_database.yml.example config/database.yml`
  end

  after do
    `cp -f config/database.yml.example config/database.yml`
  end

  it "shouldn't complain about not being able to find the environment" do
    # Since spec_helper has already loaded rails with the config in
    # database.yml.example and in the test env, and since we want to test
    # using a different database.yml in a different environment, run
    # a command in a different process that will load Rails (and its db
    # config) and then exit quickly without having side effects (as opposed
    # to running rails c or rake db:migrate).
    output = `RAILS_ENV=production DATABASE_URL=mysql://root@localhost:1234/db_charmer_dynamic bundle exec rake db:migrate:status 2>&1`

    output.should_not match(/Invalid/)
    output.should_not match(/does not exist in database.yml/)
  end
end