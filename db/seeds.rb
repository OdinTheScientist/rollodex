# Wipe in development to keep seeding idempotent
PositionVariant.destroy_all
Position.destroy_all

positions_data = [
  {
    name: "Closed Guard",
    category: :guard,
    description: "Bottom player has legs wrapped around top player's torso, ankles crossed.",
    variants: [
      { name: "Closed Guard Bottom", role: :attacker },
      { name: "Closed Guard Top",    role: :defender }
    ]
  },
  {
    name: "Side Control",
    category: :pin,
    description: "Top player controls bottom player perpendicularly, chest-on-chest pin.",
    variants: [
      { name: "Side Control Top",    role: :attacker },
      { name: "Side Control Bottom", role: :defender }
    ]
  },
  {
    name: "Mount",
    category: :pin,
    description: "Top player straddles bottom player's torso.",
    variants: [
      { name: "Mount Top",    role: :attacker },
      { name: "Mount Bottom", role: :defender }
    ]
  },
  {
    name: "Back Control",
    category: :back,
    description: "Attacker is behind defender with hooks or body triangle.",
    variants: [
      { name: "Back Attack",  role: :attacker },
      { name: "Back Defense", role: :defender }
    ]
  },
  {
    name: "Ashi Garami",
    category: :leg_entanglement,
    description: "Single leg entanglement, foot on hip, controlling one leg.",
    variants: [
      { name: "Ashi Garami Attacker", role: :attacker },
      { name: "Ashi Garami Defender", role: :defender }
    ]
  },
  {
    name: "Neutral Standing",
    category: :neutral,
    description: "Both players on their feet, no grips established or hand fighting.",
    variants: [
      { name: "Hand Fight", role: :mutual }
    ]
  },
  {
    name: "Scramble",
    category: :scramble,
    description: "Transitional chaos where neither player has structural control.",
    variants: [
      { name: "Scramble", role: :mutual }
    ]
  }
]

positions_data.each do |pos_data|
  variants = pos_data.delete(:variants)
  position = Position.create!(pos_data)
  variants.each { |v| position.variants.create!(v) }
end

puts "Seeded #{Position.count} positions and #{PositionVariant.count} variants."

# Techniques
techniques_data = [
  {
    name: "Armbar",
    technique_type: :submission,
    gi_nogi: :both,
    description: "Hyperextension of the elbow joint by isolating the arm between the legs.",
    starting_variants: [ "Closed Guard Bottom", "Mount Top", "Side Control Top" ],
    ending_variants: []
  },
  {
    name: "Triangle Choke",
    technique_type: :submission,
    gi_nogi: :both,
    description: "Blood choke using the legs to compress the carotid arteries.",
    starting_variants: [ "Closed Guard Bottom", "Mount Top" ],
    ending_variants: []
  },
  {
    name: "Guillotine",
    technique_type: :submission,
    gi_nogi: :both,
    description: "Choke applied around the neck, can be applied standing or from guard.",
    starting_variants: [ "Closed Guard Bottom", "Hand Fight" ],
    ending_variants: []
  },
  {
    name: "Scissor Sweep",
    technique_type: :sweep,
    gi_nogi: :both,
    description: "Sweep from closed guard using a scissoring leg motion to off-balance and reverse.",
    starting_variants: [ "Closed Guard Bottom" ],
    ending_variants: [ "Mount Top" ]
  },
  {
    name: "Hip Bump Sweep",
    technique_type: :sweep,
    gi_nogi: :both,
    description: "Explosive hip drive from closed guard to off-balance and reverse position.",
    starting_variants: [ "Closed Guard Bottom" ],
    ending_variants: [ "Mount Top" ]
  },
  {
    name: "Elbow Escape",
    technique_type: :escape,
    gi_nogi: :both,
    description: "Fundamental escape from mount using elbow-knee connection to recover guard.",
    starting_variants: [ "Mount Bottom" ],
    ending_variants: [ "Closed Guard Top" ]
  },
  {
    name: "Heel Hook",
    technique_type: :submission,
    gi_nogi: :nogi_only,
    description: "Rotation of the heel to apply torque on the knee joint.",
    starting_variants: [ "Ashi Garami Attacker" ],
    ending_variants: []
  },
  {
    name: "Double Leg Takedown",
    technique_type: :takedown,
    gi_nogi: :both,
    description: "Shooting in to grab both legs and drive opponent to the mat.",
    starting_variants: [ "Hand Fight" ],
    ending_variants: [ "Side Control Top", "Mount Top" ]
  }
]

techniques_data.each do |tech_data|
  starting_names = tech_data.delete(:starting_variants)
  ending_names = tech_data.delete(:ending_variants)

  technique = Technique.create!(tech_data)

  starting_names.each do |variant_name|
    variant = PositionVariant.find_by!(name: variant_name)
    technique.technique_starting_position_variants.create!(position_variant: variant)
  end

  ending_names.each do |variant_name|
    variant = PositionVariant.find_by!(name: variant_name)
    technique.technique_ending_position_variants.create!(position_variant: variant)
  end
end

puts "Seeded #{Technique.count} techniques."
