class Character < ApplicationRecord

  CHAR_ROLES = {  dps: { display_name: "Damage", display_icon: '/assets/icons/class/class_role_damage.png' },
                  healer: { display_name: "Healer", display_icon: '/assets/icons/class/class_role_healer.png' },
                  tank: { display_name: "Tank", display_icon: '/assets/icons/class/class_role_tank.png' }
  }
  CHAR_CLASSES = {  death_knight: { display_name: "Death Knight", display_icon: "/assets/icons/class/class_deathknight.jpg" }, 
                    demon_hunter: { display_name: "Demon Hunter", display_icon: "/assets/icons/class/class_demonhunter.jpg" },
                    druid: { display_name: "Druid", display_icon: "/assets/icons/class/class_druid.jpg" },
                    hunter: { display_name: "Hunter", display_icon: "/assets/icons/class/class_hunter.jpg" },
                    mage: { display_name: "Mage", display_icon: "/assets/icons/class/class_mage.jpg" },
                    monk: { display_name: "Monk", display_icon: "/assets/icons/class/class_monk.jpg" },
                    paladin: { display_name: "Paladin", display_icon: "/assets/icons/class/class_paladin.jpg" },
                    priest: { display_name: "Priest", display_icon: "/assets/icons/class/class_priest.jpg" }, 
                    rogue: { display_name: "Rogue", display_icon: "/assets/icons/class/class_rogue.jpg" }, 
                    shaman: { display_name: "Shaman", display_icon: "/assets/icons/class/class_shaman.jpg" }, 
                    warlock: { display_name: "Warlock", display_icon: "/assets/icons/class/class_warlock.jpg" },
                    warrior: { display_name: "Warrior", display_icon: "/assets/icons/class/class_warrior.jpg" }
                  }

  belongs_to :user
  has_many :attendees
  has_many :events, through: :attendees
end
