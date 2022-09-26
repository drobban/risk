import EnumType

defenum Risk.Game.State do
  value PlayerAnnouncement, :player_announcement
  value Preperation, :preperation
  value Deployment, :deployment
  value Game, :game

  default PlayerAnnouncement
end
