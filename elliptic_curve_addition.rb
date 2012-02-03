#! /usr/bin/env ruby

=begin

A simple command line tool that calculates the addition
of two points of an elliptic curve in a finite field.

E(FP): y^2 = x^3 + Ax + B

- Can only take in 2 points
- Cannot take in infinity (yet)

=end

class Elliptic_Curve
	attr_accessor :p, :a, :b

	def initialize(p, a, b)
		@p, @a, @b = p, a, b
	end

	def add_points(p1, p2)
		if p1.x == p2.x
			if p1.y == (-p2.y % @p)
				infinity
			elsif p1.y == p2.y
				tangent_add(p1, p2)
			else
				normal_add(p1, p2)
			end
		else
			normal_add(p1, p2)
		end
	end

	def infinity
		puts "\n0 (infinity)\n"
	end

	def tangent_add(p1, p2)
		# P+P
		m = 0

		m_numerator = 3*(p1.x**2) + a
		m_denominator = 2*p1.y

		m_numerator = m_numerator % @p
		m_denominator = m_denominator % @p

		if m_denominator == 0
			infinity
		else
			(1..@p).each do |a|
				if (a*m_denominator % @p) == m_numerator
					m = (a % @p)
				end
			end

			normal_add(p1, p2, m)
		end
	end

	def normal_add(p1, p2, m=-1)
		# P+Q
		if m == -1
			m = calculate_slope(p1, p2)
		end

		x3 = (m**2 - p1.x - p2.x) % @p
		y3 = (m*(p1.x-x3)-p1.y) % @p

		puts "\nE(F#{@p}): x^3 + #{@a}x + #{b}"
		puts "(#{p1.x},#{p1.y}) + (#{p2.x},#{p2.y}) = (#{x3},#{y3})\n\n"

		point_on_curve?(x3, y3)
	end

	def calculate_slope(p1, p2)
		m_numerator = (p2.y - p1.y) % @p
		m_denominator = (p2.x - p1.x) % @p

		if m_numerator == 0
			return 0
		else
			(1..@p).each do |a|
				if (a*m_denominator % @p) == m_numerator
					return (a % @p)
				end
			end
		end
	end

	def point_on_curve?(x, y)
		left_side = y**2 % @p
		right_side = (x**3 + @a*x + b) % @p

		if left_side == right_side
			puts "Point is on the curve"
		else
			puts "Point is not on the curve"
		end

		puts
	end
end

class Point
	attr_accessor :x, :y

	def initialize(x, y)
		@x, @y = x, y
	end
end

def main
	puts
	print "P: "
	input = gets
	p = Integer(input)

	print "A: "
	input = gets
	a = Integer(input)

	print "B: "
	input = gets
	b = Integer(input)

	print "x1: "
	input = gets
	x1 = Integer(input)

	print "y1: "
	input = gets
	y1 = Integer(input)

	print "x2: "
	input = gets
	x2 = Integer(input)

	print "y2: "
	input = gets
	y2 = Integer(input)

	curve = Elliptic_Curve.new(p, a, b)

	p1 = Point.new(x1, y1)
	p2 = Point.new(x2, y2)

	curve.add_points(p1, p2)
end

main