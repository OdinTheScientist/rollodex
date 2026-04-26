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
