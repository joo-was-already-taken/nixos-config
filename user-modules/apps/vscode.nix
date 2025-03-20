{ lib, pkgs, config, ... }:
let
  moduleName = "vscode";
  javaEnabled = config.modules.${moduleName}.java.enable;
  jupyterEnabled = config.modules.${moduleName}.jupyter.enable;
in {
  options.modules.${moduleName} = {
    enable = lib.mkEnableOption moduleName;
    java.enable = lib.mkEnableOption "java development envirenment";
    jupyter.enable = lib.mkEnableOption "jupyter notebook";
  };

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.packages = with pkgs; [
      # find-it-faster dependencies
      fzf ripgrep bat
    ] ++ lib.lists.optionals javaEnabled [ jdk maven ];

    stylix.targets.vscode.enable = false;

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc
        vscodevim.vim
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "find-it-faster";
          publisher = "tomrijndorp";
          version = "0.0.39";
          sha256 = "sha256-Rr1EKYSYmY52FfG4ClSQyikr0fd4cFKjphNxpzhiraw=";
        }
      ] ++ lib.lists.optionals javaEnabled [
        redhat.java
        vscjava.vscode-gradle
        vscjava.vscode-maven
        vscjava.vscode-java-test
        vscjava.vscode-java-debug
        vscjava.vscode-java-dependency
      ] ++ lib.lists.optionals jupyterEnabled [
        ms-toolsai.jupyter
        ms-python.python
      ];

      userSettings = {
        telemetry.telemetryLevel = "off";
        redhat.telemetry.enabled = false;

        editor.bracketPairColorization.enabled = false;
        editor.lineNumbers = "relative";
        editor.acceptSuggestionOnEnter = "off";
        editor.minimap.enabled = false;

        workbench.colorTheme = "Catppuccin Macchiato";
        catppuccin.accentColor = "blue";

        vim.normalModeKeyBindings = [
          {
            before = [ "<C-d>" ];
            after = [ "<C-d>" "z" "z" ];
          }
          {
            before = [ "<C-u>" ];
            after = [ "<C-u>" "z" "z" ];
          }
        ];
        vim.visualModeKeyBindings = [
          {
            before = [ "<" ];
            after = [ "<" "g" "v" ];
          }
          {
            before = [ ">" ];
            after = [ ">" "g" "v" ];
          }
        ];
      };

      keybindings = [
        {
          key = "ctrl+l";
          command = "workbench.action.nextEditor";
        }
        {
          key = "ctrl+h";
          command = "workbench.action.previousEditor";
        }
        {
          key = "ctrl+c";
          command = "workbench.action.closeActiveEditor";
        }
        {
          key = "ctrl+enter";
          command = "workbench.action.terminal.focus";
        }
        {
          key = "ctrl+y";
          command = "acceptSelectedSuggestion";
          when = "suggestWidgetVisible && textInputFocus";
        }
        {
          key = "ctrl+n";
          command = "selectNextSuggestion";
          when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
        }
        {
          key = "ctrl+p";
          command = "selectPrevSuggestion";
          when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
        }
      ];
    };
  };
}
