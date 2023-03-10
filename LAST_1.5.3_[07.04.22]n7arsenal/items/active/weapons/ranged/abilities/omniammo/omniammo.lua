OmniAmmo = WeaponAbility:new()

function OmniAmmo:init()
  self.ammoIndex = math.min(config.getParameter("ammoIndex", 1), #self.ammoTypes)
  self:adaptAbility()

  self.weapon.onLeaveAbility = function()
    self.weapon:setStance(self.stances.idle)
  end
end

function OmniAmmo:update(dt, fireMode, shiftHeld)
  WeaponAbility.update(self, dt, fireMode, shiftHeld)

  if not self.weapon.currentAbility and self.fireMode == (self.activatingFireMode or self.abilitySlot) then
    self:setState(self.switch)
  end
end

function OmniAmmo:switch()
  self.ammoIndex = (self.ammoIndex % #self.ammoTypes) + 1
  activeItem.setInstanceValue("ammoIndex", self.ammoIndex)

  self:adaptAbility()
  animator.playSound("switchAmmo")

  self.weapon:setStance(self.stances.switch)

  util.wait(self.stances.switch.duration)
end

function OmniAmmo:adaptAbility()
  local ability = self.weapon.abilities[self.adaptedAbilityIndex]
  util.mergeTable(ability, self.ammoTypes[self.ammoIndex])
  animator.setAnimationState("ammoType", tostring(self.ammoIndex))
end

function OmniAmmo:uninit()
end
