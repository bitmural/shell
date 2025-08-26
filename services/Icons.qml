pragma Singleton

import Quickshell
import Quickshell.Services.Notifications

Singleton {
  id: root

  readonly property var osIcons: ({
    almalinux: "",
    alpine: "",
    arch: "",
    archcraft: "",
    arcolinux: "",
    artix: "",
    centos: "",
    debian: "",
    devuan: "",
    elementary: "",
    endeavouros: "",
    fedora: "",
    freebsd: "",
    garuda: "",
    gentoo: "",
    hyperbola: "",
    kali: "",
    linuxmint: "󰣭",
    mageia: "",
    openmandriva: "",
    manjaro: "",
    neon: "",
    nixos: "",
    opensuse: "",
    suse: "",
    sles: "",
    sles_sap: "",
    "opensuse-tumbleweed": "",
    parrot: "",
    pop: "",
    raspbian: "",
    rhel: "",
    rocky: "",
    slackware: "",
    solus: "",
    steamos: "",
    tails: "",
    trisquel: "",
    ubuntu: "",
    vanilla: "",
    void: "",
    zorin: ""
  })
}
