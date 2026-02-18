#!/usr/bin/env python3
"""
test tray app — registers a StatusNotifier item with a full context menu.
run with: nix-shell -p python3 python3Packages.pygobject3 libappindicator-gtk3 gobject-introspection gtk3 --run "python3 test-tray-app.py"
"""

import signal
import gi

gi.require_version("Gtk", "3.0")
gi.require_version("AppIndicator3", "0.1")

from gi.repository import Gtk, AppIndicator3, GLib


def on_action(widget, label):
    print(f"triggered: {label}")


def on_toggle(widget):
    state = "ON" if widget.get_active() else "OFF"
    print(f"toggled: {widget.get_label()} -> {state}")


def on_quit(_widget):
    print("quit requested")
    Gtk.main_quit()


def build_menu():
    menu = Gtk.Menu()

    item_open = Gtk.MenuItem(label="Open Window")
    item_open.connect("activate", on_action, "Open Window")
    menu.append(item_open)

    item_settings = Gtk.MenuItem(label="Settings")
    item_settings.connect("activate", on_action, "Settings")
    menu.append(item_settings)

    menu.append(Gtk.SeparatorMenuItem())

    item_check = Gtk.CheckMenuItem(label="Enable Feature")
    item_check.set_active(True)
    item_check.connect("toggled", on_toggle)
    menu.append(item_check)

    item_check2 = Gtk.CheckMenuItem(label="Dark Mode")
    item_check2.set_active(False)
    item_check2.connect("toggled", on_toggle)
    menu.append(item_check2)

    menu.append(Gtk.SeparatorMenuItem())

    submenu = Gtk.Menu()
    for name in ["Profile A", "Profile B", "Profile C"]:
        sub_item = Gtk.MenuItem(label=name)
        sub_item.connect("activate", on_action, name)
        submenu.append(sub_item)

    item_profiles = Gtk.MenuItem(label="Profiles")
    item_profiles.set_submenu(submenu)
    menu.append(item_profiles)

    item_disabled = Gtk.MenuItem(label="Unavailable")
    item_disabled.set_sensitive(False)
    menu.append(item_disabled)

    menu.append(Gtk.SeparatorMenuItem())

    item_quit = Gtk.MenuItem(label="Quit")
    item_quit.connect("activate", on_quit)
    menu.append(item_quit)

    menu.show_all()
    return menu


def main():
    signal.signal(signal.SIGINT, signal.SIG_DFL)

    indicator = AppIndicator3.Indicator.new(
        "test-tray-app",
        "applications-system",
        AppIndicator3.IndicatorCategory.APPLICATION_STATUS,
    )
    indicator.set_status(AppIndicator3.IndicatorStatus.ACTIVE)
    indicator.set_title("Test Tray App")
    indicator.set_menu(build_menu())

    print("test tray app running — right-click the tray icon to see the menu")
    print("press ctrl+c to quit")
    Gtk.main()


if __name__ == "__main__":
    main()
