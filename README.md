# Risk

**TODO: Add description**

Game states

    * Player announcements
      - Connecting - DONE
      - Ready - By consensus (when all connected say ready) - DONE
    * Preperation
      - Troop allocation - DONE
      - Color selection - DONE
    * Deployment
      - Task assignment - Need to filter out color based tasks - DONE
      - Troop deployment
    * GAME
      - Reinforcements
      - Battle

Player
      
Game board

    - Consists of countries - DONE
    
Task cards

    - Assignment - DONE
    - Task functions to check if fulfilled

Risk cards
    
    - Troop value - DONE
    - Country - DONE

    - Card pile - DONE

GAME MACHINE
    
    - add initialisation of CardPile.
    - refactor GameContext to exclude risk_cards
    - refactor game logic to take cards from CardPile instead.
    
Army
    
Dice
    

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `risk` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:risk, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/risk>.

