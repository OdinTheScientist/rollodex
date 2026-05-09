if Rails.env.development?
  namespace :annotate do
    desc "Update schema annotations on models"
    task models: :environment do
      system "bundle exec annotaterb models"
    end
  end

  Rake::Task["db:migrate"].enhance do
    Rake::Task["annotate:models"].invoke
  end

  Rake::Task["db:migrate:up"].enhance do
    Rake::Task["annotate:models"].invoke
  end
end
