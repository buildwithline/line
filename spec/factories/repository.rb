# frozen_string_literal: true

FactoryBot.define do
  factory :repository do
    full_name { 'user/new_repo' }
    name { 'new_repo' }
    html_url { 'http://github.com/user/new_repo' }
    description { 'A new repo' }
    private { false }
    fork { false }
    created_at { 5.minutes.before(Time.current) }
    updated_at { 5.minutes.before(Time.current) }
    created_on_github_at { 5.minutes.before(Time.current) }
    updated_on_github_at { 5.minutes.before(Time.current) }
    pushed_to_github_at { 5.minutes.before(Time.current) }
  end
end
