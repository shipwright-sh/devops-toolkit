# VSCode Remote Container: devops-toolkit

![CI/CD](https://github.com/shipwright-sh/devops-toolkit/actions/workflows/workflow.yaml/badge.svg)

The `devops-toolkit` is a **development container**. For more information on development containers please see [Development Containers](). The `devops-container` was designed to provide new DevOps engineers joining the team with a standardized local development environment so they no longer have to spend time manually setting up their environment, downloading CLI tools and software packages.

### `platform_install_role`

| Package Name | Version |
|--------------|---------|
| ansible      | 4.10.0  |
| terraform    | 1.2.9   |
| helm         | 3.9.4   |
| kubectl      | 1.25.1  |

### `github_download_packages`

| Package Name | Version |
|--------------|---------|
| tfsec        | 1.27.6  |
| grype        | 0.50.1  |
| tk           | 0.22.1  |
| jb           | v0.5.1  |
| kind         | 0.15.0  |

### `pip_install_packages`
| Package Name | Version |
|--------------|---------|
| bashate      | 2.1.0   |
| molecule     | 4.0.1   |

### **Setting up the `devops-toolkit`**

#### **1. Running the container manualy.**
1. Pull the latest version of the `devops-toolkit` from the container registry/
```
docker pull lmctague/devops-toolkit:e9f255e1bf475a2f6fa845ac3c2bce7670fb1fdf
```
2. Stat a shell insider the container.
```
docker run -it lmctague/devops-toolkit:e9f255e1bf475a2f6fa845ac3c2bce7670fb1fdf bash
```

#### **2. Using it in a project.**
1. Clone your project repo to your local filesystem.
2. Create a new `.devcontainer/devcontainer.json` file in our project. (Use the `example.devcontainer.json` in this repo as a template)
4. Make any changes as you see nessesary.
5. Press `F1` and select the **Remote-Containers: Open Folder in Container**... command.
4. Select the cloned copy of our project folder, wait for the container to start, and try things out!

### **Contribute**

1. Clone the `devops-toolkit` repo and create a new branch.

```
git clone https://gitlab.idkit.co/liam.mctague/devops-toolkit
cd devops-toolkit
git checkout -b <branch-name>
```

2. Commit and push your changes to the new branch using the commit message guildlines or use `cz commit`.

```
cz commit
git push
```

3. Create a new merge request using the template found in the `.gitlab` folder in this repo.