local Converge(distro) = {
  name: "Converge - "+distro,
  image: "quay.io/ansible/molecule",
  commands: [
    "molecule destroy",
    "molecule converge",
    "molecule destroy",
  ],
  environment:
    { MOLECULE_DISTRO: +distro, },
  privileged: true,
  volumes: [
    { name: "docker", path: "/var/run/docker.sock" },
  ],
};

[
  {
    name: "Lint",
    kind: "pipeline",
    steps: [
      {
        name: "Lint code",
        image: "quay.io/ansible/molecule",
        commands: [
          "molecule lint",
          "molecule syntax"
        ]
      }
    ]
  },
  {
    kind: "pipeline",
    name: "Test",
    steps: [
      Converge("debian9"),
      Converge("ubuntu1804"),
    ],
    volumes: [
      { name: "docker",
        host: { path: "/var/run/docker.sock" }
      },
    ],
    networks: [
      { name: "acmenet",
        subnet: "10.30.50.0/24",
        attachable: "true",
      },
    ],
    services: [
      { name: "pebble",
        image: "letsencrypt/pebble",
        commands: [
          "pebble -config /test/my-pebble-config.json --dnsserver 10.30.50.10:53",
        ],
        networks: {
          acmenet: {
            ipv4_address: "10.30.50.2"
          },
        },
      },
    ],

    depends_on: [
      "Lint",
    ],
  },
  {
    name: "Publish",
    kind: "pipeline",
    steps: [
      {
        name: "Ansible Galaxy",
        image: "quay.io/ansible/molecule",
        commands: [
          "ansible-galaxy login --github-token $$GITHUB_TOKEN",
          "ansible-galaxy import Thulium-Drake ansible-role-vmware --role-name=acme_ssl",
        ],
        environment:
          { GITHUB_TOKEN: { from_secret: "github_token" } },
        when:
        {
          cron: [
            "weekly-build",
          ],
          event: [
            "tag",
          ],
        },
      },
    ],
    depends_on: [
      "Test",
    ],
  },
]
