# frozen_string_literal: true

class Withdrawal
  # Order is important. It must be highest first, lowest last
  BILLS = [50, 20, 2].freeze
  private_constant :BILLS

  def initialize(amount)
    @amount = amount
    @configurations = []
  end

  def options
    with_elements = 1

    until enough_combinations
      candidate = find_candidate(with_elements)

      add_candidate_to_configurations(candidate)

      with_elements += 1
    end

    configurations
  end

  private

  attr_reader :amount, :configurations

  def enough_combinations
    configurations.count == number_of_configurations
  end

  def number_of_configurations
    amount < 20 ? 1 : 2
  end

  def find_candidate(with_elements)
    BILLS.repeated_combination(with_elements).select { |combination| equals_amount?(combination) }
  end

  def equals_amount?(combination)
    combination.inject(:+) == amount
  end

  def add_candidate_to_configurations(candidate)
    configurations.push(candidate.flatten) unless candidate.empty?
  end
end
