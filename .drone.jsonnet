local Clone() = {
  name: "Clone",
  image: "drone/git",
  commands: [
    "mkdir $HOME/.ssh",
    "chmod 0700 $HOME/.ssh",
    "echo $$DRONE_CLONE_KEY | base64 -d > $HOME/.ssh/id_ed25519",
    "chmod 0600 $HOME/.ssh/id_ed25519",
    'echo -e "
      Host *
        StrictHostKeyChecking accept-new
      " > $HOME/.ssh/config',
    "ssh git@$${DRONE_CLONE_HOST}",
    "git clone ssh://git@$${DRONE_CLONE_HOST}/${DRONE_REPO} .",
    "git checkout ${DRONE_COMMIT_BRANCH}"
  ],
  environment:
    { DRONE_CLONE_KEY: { from_secret: 'drone_clone_key' },
      DRONE_CLONE_HOST: { from_secret: 'drone_clone_host' } },
};

local Converge(distro) = {
  name: "Converge - "+distro,
  image: "registry.element-networks.nl/tools/molecule",
  commands: [
    "molecule destroy",
    "molecule converge",
    "molecule idempotence",
    "molecule destroy",
  ],
  environment:
    { MOLECULE_DISTRO: distro, },
  privileged: true,
  volumes: [
    { name: "docker", path: "/var/run/docker.sock" },
  ],
  networks: [
    { name: "acmenet",
      ipv4_address: "10.30.50.20",
    }
  ],
};

[
  {
    name: "Lint",
    kind: "pipeline",
    clone:
      { disable: true },
    steps: [
      Clone(),
      {
        name: "Lint code",
        image: "registry.element-networks.nl/tools/molecule",
        privileged: true,
        volumes: [
          { name: "docker", path: "/var/run/docker.sock" },
        ],
        commands: [
          "molecule lint",
          "molecule syntax"
        ]
      }
    ],
    volumes: [
      { name: "docker",
        host: { path: "/var/run/docker.sock" }
      },
    ],
  },
  {
    name: "Test",
    kind: "pipeline",
    clone:
      { disable: true },
    steps: [
      Clone(),
      Converge("debian10"),
      Converge("ubuntu2004"),
      Converge("centos8"),
    ],
    volumes: [
      { name: "docker",
        host: { path: "/var/run/docker.sock" }
      },
    ],

    depends_on: [
      "Lint",
    ],
  },
  {
    name: "Publish",
    kind: "pipeline",
    clone:
      { disable: true },
    steps: [
      {
        name: "Ansible Galaxy",
        image: "registry.element-networks.nl/tools/molecule",
        commands: [
          "ansible-galaxy import --token $$GALAXY_TOKEN Thulium-Drake ansible-role-acme_ssl --role-name=acme_ssl",
        ],
        environment:
          { GALAXY_TOKEN: { from_secret: "galaxy_token" } },
      },
    ],
    depends_on: [
      "Test",
    ],
  },
]
