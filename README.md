# Satre

Congito ergo sum - I think therefore I am.

[![Build Status](https://travis-ci.org/RomanCPodolski/satre.svg)](https://travis-ci.org/RomanCPodolski/satre)
[![Code Climate](https://codeclimate.com/github/RomanCPodolski/satre/badges/gpa.svg)](https://codeclimate.com/github/RomanCPodolski/satre)
[![Test Coverage](https://codeclimate.com/github/RomanCPodolski/satre/badges/coverage.svg)](https://codeclimate.com/github/RomanCPodolski/satre/coverage)
[![Issue Count](https://codeclimate.com/github/RomanCPodolski/satre/badges/issue_count.svg)](https://codeclimate.com/github/RomanCPodolski/satre)
  
Satre is a library for proportional and first order logic problem solving in ruby.
It was inspired by the book ['Handbook of practical logic and automated reasoning' by Harrison, J (2009)](http://www.cambridge.org/us/academic/subjects/computer-science/programming-languages-and-applied-logic/handbook-practical-logic-and-automated-reasoning).
  
This project originated at the [Technical University Munich](http://www.tum.de) as a students project in the lecture ['Basics of Artificial Intelligence'](http://www6.in.tum.de/Main/TeachingWs2014KuenstlicheIntelligenz).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'satre'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install satre

## Usage

For examples look at the file `bin/exercise`.
The see the results of the exercise run `./bin/exercise` from the root directory of this project.

To embed proportional logic solving in your project one can use `String#to_formula`, on a well formed proportional logic string.
Possible operations are

  * True value `"true"`
  * False value `"false"`
  * Atomic logical variable `"A"` (or any other alphanumeric combination)
  * logical negation `"~A"`
  * logical and `"A /\\ B"`
  * logical or `"A \\/ B"`
  * Implies `"A <=> B"`
  * If and only if `"A ==> B"`
  * Entails `"A |= B"`
  * Forall `"forall x. y"`
  * Exists `"exists x. y"`

An example

```ruby
formula = '(Fire ==> Smoke) /\\ Fire /\\ ~Smoke'.to_formula 
```
For more examples check [bin/exercise_4](https://github.com/RomanCPodolski/satre/blob/master/bin/exercise_4) and [bin/exercise_5](https://github.com/RomanCPodolski/satre/blob/master/bin/exercise_5) To evaluate a formula use `Satre::Formula#eval`

```ruby
formula = '(Fire ==> Smoke) /\\ Fire /\\ ~Smoke'.to_formula 
formula.eval Fire: true, Smoke: true
```

Further are provided `Satre::Formula#tauntolgy?`,`Satre::Formula#satisfiable?`,`Satre::Formula#unsatisfiable?`, `Satre::Formula#holds?`,`Satre::Formula#wellformed?`

For further information see the doc.

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RomanCPodolski/satre.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
