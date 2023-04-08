{-# LANGUAGE OverloadedStrings #-}

import Data.Default (def)
import System.Taffybar
import System.Taffybar.Information.CPU
import System.Taffybar.SimpleConfig
import System.Taffybar.Widget
import System.Taffybar.Widget.Generic.Graph
import System.Taffybar.Widget.Generic.PollingGraph

cpuCallback = do
  (_, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

main = do
  let cpuCfg =
        def
          { graphDataColors = [(0, 1, 0, 1), (1, 0, 1, 0.5)],
            graphLabel = Just "cpu"
          }
      clock = textClockNewWith def
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      workspaces = workspacesNew def
      simpleConfig =
        def
          {
          -- startWidgets = [workspaces],
          endWidgets = [workspaces, sniTrayNew, clock, cpu]
            -- endWidgets = [clock, cpu]
          }
  simpleTaffybar simpleConfig
