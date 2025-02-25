# Copyright (c) 2023 BirdeeHub 
# Licensed under the MIT license 
/* 
  # paste the inputs you don't have in this set into your main system flake.nix
  # (lazy.nvim wrapper only works on unstable)
  inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  nixCats.url = "github:BirdeeHub/nixCats-nvim";
  nixCats.inputs.nixpkgs.follows = "nixpkgs";
  };

  Then call this file with:
  myNixCats = import ./path/to/this/dir { inherit inputs; };
  And the new variable myNixCats will contain all outputs of the normal flake format.
  You can then pass them around, export them from the overall flake, etc.

  The following is just the outputs function from the flake template.
 */
{ inputs, ... }@attrs:
let
  inherit (inputs) nixpkgs;
  inherit (inputs.nixCats) utils;
  luaPath = "${./.}";
  forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
  # the following extra_pkg_config contains any values
  # which you want to pass to the config set of nixpkgs
  # import nixpkgs { config = extra_pkg_config; inherit system; }
  # will not apply to module imports
  # as that will have your system values
  extra_pkg_config = {
    # allowUnfree = true;
  };
  inherit (forEachSystem (system:
    let
      # see :help nixCats.flake.outputs.overlays
      # This overlay grabs all the inputs named in the format
      # `plugins-<pluginName>`
      # Once we add this overlay to our nixpkgs, we are able to
      # use `pkgs.neovimPlugins`, which is a set of our plugins.
      dependencyOverlays = /* (import  ./overlays inputs ) ++ */ [
        (utils.standardPluginOverlay inputs)
        # add any flake overlays here.
      ];
    in
    { inherit dependencyOverlays; })) dependencyOverlays;

  categoryDefinitions = { pkgs, settings, categories, name, ... }@packageDef:
    let
      # this probably wants to be an overlay at somepoint
      melange = pkgs.vimUtils.buildVimPlugin {
        name = "melange-nvim";
        patches = [
          ./patches/melange.patch
        ];
        src = pkgs.fetchFromGitHub {
          owner = "savq";
          repo = "melange-nvim";
          rev = "f626d41b9110e6ab853538d8b939979a0f1adfeb";
          sha256 = "+U+G8xHvon3e2UpOcary03HOa244K7lVCYAAgMCYqqc=";
        };
      };
      yorumi = pkgs.vimUtils.buildVimPlugin {
        name = "yorumi-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "yorumicolors";
          repo = "yorumi.nvim";
          rev = "7bd484b82d1d7748d2ed73a12dbafad016c558fe";
          sha256 = "P1yV7vSiNNQgl7ZEKw7F8PwD7nfujNUkfl7XvPt1Hsw=";
        };
      };
      # this is failing to build
      # neotest-golang = pkgs.vimUtils.buildVimPlugin {
      #   name = "neotest-golang";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "fredrikaverpil";
      #     repo = "neotest-golang";
      #     rev = "247ffd9de9f8b86bd426b7bd6686902ae500b506";
      #     sha256 = "AaOteL7rN9rlC5KCjaKv2kbpv8arBqcu7wtPhBnDiZE=";
      #   };
      #   buildInputs = with pkgs; [ vimPlugins.neotest vimPlugins.nvim-dap go ];
      # };
      persistent-breakpoints-nvim = pkgs.vimUtils.buildVimPlugin {
        name = "persistent-breakpoints-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "Weissle";
          repo = "persistent-breakpoints.nvim";
          rev = "4b199b1dcfd136cac8b0fa9c8dbbdeb81463f7a9";
          sha256 = "euwc9XD02g8W52Z8SzjSInLnatS3aGLY44Frvd+yDTc=";
        };
        buildInputs = with pkgs; [ vimPlugins.nvim-dap ];
      };
      yeet-nvim = pkgs.vimUtils.buildVimPlugin {
        name = "yeet-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "samharju";
          repo = "yeet.nvim";
          rev = "a471b0d7d9164d57d9344d6bc839530eb05e9241";
          sha256 = "ysjHywKClq3WncltXnK0xDcm+T7xqW1FLZxNesseau8=";
        };
      };
    in
    {

      propagatedBuildInputs = {
        generalBuildInputs = with pkgs; [
        ];
      };

      lspsAndRuntimeDeps = {
        general = with pkgs; [
          fzf
          ripgrep
          fd
        ];
        lsps = with pkgs; [
          nix-doc
          nil
          lua-language-server
          stylua
          nixd
          gopls
          goimports-reviser
          elixir-ls
          erlfmt
        ];
      };

      startupPlugins = with pkgs.vimPlugins;{
        colorschemes = [
          yorumi
          gruvbox-material
          kanagawa-nvim
        ];
        general = [
          lualine-nvim
          oil-nvim
          fidget-nvim
          comment-nvim
          which-key-nvim
          indent-blankline-nvim
          vim-lastplace
          undotree
          nvim-surround
          better-escape-nvim
          toggleterm-nvim
          vim-sneak
          noice-nvim
          yeet-nvim
          nui-nvim
          tabout-nvim

          fzf-lua

          nvim-web-devicons
          plenary-nvim
        ];
        gitPlugins = [
          gitsigns-nvim
          diffview-nvim
          vim-fugitive
        ];
        lsps = [
          nvim-treesitter-textobjects
          nvim-treesitter.withAllGrammars

          nvim-lspconfig
          cmp-nvim-lsp
          neodev-nvim

          nvim-cmp
          luasnip
          cmp_luasnip
          cmp-buffer
          cmp-path
          cmp-nvim-lua
        ];
        dap = [
          nvim-dap-ui
          nvim-dap-virtual-text
          nvim-dap-go
          nvim-dap
          nvim-nio
          persistent-breakpoints-nvim
          neotest
          plenary-nvim
          # neotest-golang
        ];
        format = [
          conform-nvim
        ];
      };


      optionalPlugins = {
        customPlugins = with pkgs.nixCatsBuilds; [ ];
        gitPlugins = with pkgs.neovimPlugins; [ ];
        general = with pkgs.vimPlugins; [ ];
      };

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {
        general = with pkgs; [
          # libgit2
        ];
      };

      environmentVariables = {
        test = {
          CATTESTVAR = "It worked!";
        };
      };

      extraWrapperArgs = {
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
        test = [
          '' --set CATTESTVAR2 "It worked again!"''
        ];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages

      # get the path to this python environment
      # in your lua config via
      # vim.g.python3_host_prog
      # or run from nvim terminal via :!<packagename>-python3
      extraPython3Packages = {
        test = (_: [ ]);
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
        test = [ (_: [ ]) ];
      };

    };

  packageDefinitions = {
    nixCats = { pkgs, ... }: {
      # they contain a settings set defined above
      # see :help nixCats.flake.outputs.settings
      settings = {
        wrapRc = true;
        # IMPORTANT:
        # you may not alias to nvim
        # your alias may not conflict with your other packages.
        aliases = [ "vim" ];
        # caution: this option must be the same for all packages.
        # or at least, all packages that are to be installed simultaneously.
        # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
      };
      # and a set of categories that you want
      # (and other information to pass to lua)
      categories = {
        general = true;
        colorschemes = true;
        format = true;
        lsps = true;
        dap = true;
        generalBuildInputs = true;
        gitPlugins = true;
        test = true;
        colorscheme = "kanagawa";
        example = {
          youCan = "add more than just booleans";
          toThisSet = [
            "and the contents of this categories set"
            "will be accessible to your lua with"
            "nixCats('path.to.value')"
            "see :help nixCats"
          ];
        };
      };
    };
  };
  # In this section, the main thing you will need to do is change the default package name
  # to the name of the packageDefinitions entry you wish to use as the default.
  defaultPackageName = "nixCats";
in
# see :help nixCats.flake.outputs.exports
forEachSystem
  (system:
    let
      inherit (utils) baseBuilder;
      customPackager = baseBuilder luaPath
        {
          inherit system dependencyOverlays extra_pkg_config nixpkgs;
        }
        categoryDefinitions;
      nixCatsBuilder = customPackager packageDefinitions;
      # this is just for using utils such as pkgs.mkShell
      # The one used to build neovim is resolved inside the builder
      # and is passed to our categoryDefinitions and packageDefinitions
      pkgs = import nixpkgs { inherit system; };
    in
    {
      # this will make a package out of each of the packageDefinitions defined above
      # and set the default package to the one named here.
      packages = utils.mkPackages nixCatsBuilder packageDefinitions defaultPackageName;

      # choose your package for devShell
      # and add whatever else you want in it.
      devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [ (nixCatsBuilder defaultPackageName) ];
          inputsFrom = [ ];
          shellHook = ''
        '';
        };
      };

      # To choose settings and categories from the flake that calls this flake.
      # and you export overlays so people dont have to redefine stuff.
      inherit customPackager;
    }) // {

  # these outputs will be NOT wrapped with ${system}

  # this will make an overlay out of each of the packageDefinitions defined above
  # and set the default overlay to the one named here.
  overlays = utils.makeOverlays luaPath
    {
      # we pass in the things to make a pkgs variable to build nvim with later
      inherit nixpkgs dependencyOverlays extra_pkg_config;
      # and also our categoryDefinitions
    }
    categoryDefinitions
    packageDefinitions
    defaultPackageName;

  # we also export a nixos module to allow configuration from configuration.nix
  nixosModules.default = utils.mkNixosModules {
    inherit defaultPackageName dependencyOverlays luaPath
      categoryDefinitions packageDefinitions nixpkgs;
  };
  # and the same for home manager
  homeModule = utils.mkHomeModules {
    inherit defaultPackageName dependencyOverlays luaPath
      categoryDefinitions packageDefinitions nixpkgs;
  };
  # now we can export some things that can be imported in other
  # flakes, WITHOUT needing to use a system variable to do it.
  # and update them into the rest of the outputs returned by the
  # eachDefaultSystem function.
  inherit utils categoryDefinitions packageDefinitions dependencyOverlays;
  inherit (utils) templates baseBuilder;
  keepLuaBuilder = utils.baseBuilder luaPath;
}
