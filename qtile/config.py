from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

mod = "mod4"
terminal = "alacritty"

keys = [
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "Tab", lazy.screen.toggle_group(), desc="focus on last used window"),
    Key([mod], "z", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod, "shift"],
        "b",
        lazy.hide_show_bar(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_bsp(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "shift"], "q", lazy.spawn("poweroff"), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "b", lazy.spawn("falkon"), desc="staart Firefox"),
    Key([mod], "s", lazy.spawn("flameshot gui"), desc="take scrennshot"),
]

for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


groups = [Group(f"{i + 1}", label="") for i in range(5)]

for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
        ]
    )

lay_config = {
    "border_width": 0,
    "margin": 9,
    "border_focus": "",
    "border_normal": "",
    "font": "FiraCode Nerd Font",
    "grow_amount": 2,
}

layouts = [
    # layout.MonadWide(**lay_config),
    layout.Bsp(**lay_config, fair=False, border_on_single=True),
    layout.Columns(
        **lay_config,
        border_on_single=True,
        num_columns=2,
        split=False,
    ),
    # Plasma(lay_config, border_normal_fixed='#3b4252', border_focus_fixed='#3b4252', border_width_single=3),
    # layout.RatioTile(**lay_config),
    # layout.VerticalTile(**lay_config),
    # layout.Matrix(**lay_config, columns=3),
    # layout.Zoomy(**lay_config),
    # layout.Slice(**lay_config, width=1920, fallback=layout.TreeTab(), match=Match(wm_class="joplin"), side="right"),
    # layout.MonadTall(**lay_config),
    # layout.Tile(shift_windows=True, **lay_config),
    # layout.Stack(num_stacks=2, **lay_config),
    layout.Floating(**lay_config),
    layout.Max(**lay_config),
]

widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    font="JetBrainsMono Nerd Font",
                    fontsize=24,
                    borderwidth=3,
                    highlight_method="block",
                    active="#A0A0A0",
                    block_highlight_text_color="#82D9C2",
                    highlight_color="#353446",
                    inactive="#282738",
                    foreground="#4B427E",
                    background="#353446",
                    this_current_screen_border="#353446",
                    this_screen_border="#353446",
                    other_current_screen_border="#353446",
                    other_screen_border="#353446",
                    urgent_border="#353446",
                    rounded=True,
                    disable_drag=True,
                ),
                widget.Spacer(
                    length=8,
                    background="#353446",
                ),
                widget.WindowName(
                    background="#353446",
                    font="JetBrainsMono Nerd Font Bold",
                    fontsize=13,
                    empty_group_string="Desktop",
                    max_chars=130,
                    foreground="#82D9C2",
                ),
                widget.Systray(
                    background="#282738",
                    fontsize=2,
                ),
                widget.Prompt(
                    background="#353446",
                    font="JetBrainsMono Nerd Font Bold",
                    fontsize=13,
                    max_chars=130,
                    foreground="#82D9C2",
                ),
                widget.Systray(
                    background="#282738",
                    fontsize=2,
                ),
                widget.TextBox(
                    text=" ",
                    background="#282738",
                ),
                widget.Spacer(
                    length=8,
                    background="#353446",
                ),
                widget.Memory(
                    background="#353446",
                    format="RAM:{MemUsed: .0f}{mm}",
                    foreground="#82D9C2",
                    font="JetBrainsMono Nerd Font Bold",
                    fontsize=13,
                    update_interval=5,
                ),
                widget.Spacer(
                    length=8,
                    background="#353446",
                ),
                widget.Spacer(
                    length=8,
                    background="#282738",
                ),
                widget.TextBox(
                    text=" ",
                    font="Font Awesome 6 Free Solid",
                    fontsize=13,
                    background="#282738",
                    foreground="#82D9C2",
                ),
                widget.Clock(
                    format="%I:%M %p",
                    background="#282738",
                    foreground="#82D9C2",
                    font="JetBrainsMono Nerd Font Bold",
                    fontsize=13,
                ),
                widget.Spacer(
                    length=18,
                    background="#282738",
                ),
            ],
            30,
            border_color="#282738",
            border_width=[0, 0, 0, 0],
            margin=[6, 9, 6, 9],
        ),
    ),
]

mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

auto_minimize = True

wl_input_rules = None

wl_xcursor_theme = None
wl_xcursor_size = 24

wmname = "LG3D"
