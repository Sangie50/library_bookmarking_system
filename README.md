# LSP Management System

A system for the management and viewing of student Learning Support Plans (LSPs) for The University of Sheffield Disability and Dyslexia Support Service (DDSS).

## Features

- Ability to add LSP information to the system by PDF extraction
- Login with university login details, with Single Sign-On via CAS if possible
- Role-restricted access to LSPs and student information
- Ability to view students by department and module
- Allows academics to view students that they are teaching, tutoring and supervising

## Requirements

This app has been developed and tested in Ruby using Rails, using RVM for ruby version management and PostgreSQL 12 as the database backend.

- Ruby 2.6.6
- PostgreSQL 12

Ruby gem requirements are managed by Bundler and are detailed in full in [`Gemfile`](./Gemfile).

## Development

It's recommended that you use RVM to install the correct Ruby version for this system.

Once you have cloned this repository for local development, you can setup the project for development by running

```sh
bin/setup
```

This will install packages in `Gemfile`, create a database configuration file in [`config/database.yml`](./config/database.yml), and setup and seed the database.

Run the development server using

```sh
bundle exec rails server
```

## Deployment

Deployment can be done using the `epi-deploy` gem.

```sh
bundle exec epi_deploy release -d <environment>
```

where `<environment>` is the environment to which you are deploying the application.

## Customer Contact

[//]: # (#TODO: Add customer contact details)
