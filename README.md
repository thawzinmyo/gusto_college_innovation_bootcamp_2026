# GUSTO College Innovation Bootcamp 2026
### Host a Static Website on AWS S3 with Terraform

> **Duration:** 3 days · **Level:** Beginner–Intermediate · **Prerequisites:** None

This hands-on workshop walks you through every step — from installing tools on your
laptop to deploying a real, publicly-accessible website on Amazon S3 using
Terraform (Infrastructure as Code).

---

## Repository Structure

```
gusto_college_innovation_bootcamp_2026/
├── website/                   ← The static website you will deploy
│   ├── index.html             ← Main HTML page (edit this!)
│   ├── style.css              ← Styling (change colors here!)
│   └── script.js              ← Interactivity (toggle buttons here!)
├── terraform/                 ← Infrastructure as Code
│   ├── main.tf                ← S3 bucket + website config
│   ├── variables.tf           ← Input variables
│   ├── outputs.tf             ← Outputs (website URL)
│   └── terraform.tfvars.example  ← Copy this to terraform.tfvars
└── README.md                  ← This file
```

---

## Part 1 — Setup on Your Laptop

### Step 1 · Install Terraform

Pick your operating system:

<details>
<summary><strong>macOS</strong></summary>

**Option A — Homebrew (recommended)**
```bash
# Install Homebrew first if you don't have it
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Terraform
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

**Option B — Manual download**
1. Go to https://developer.hashicorp.com/terraform/downloads
2. Download the **macOS ARM64** (Apple Silicon M1/M2/M3) or **macOS AMD64** (Intel) zip file
3. Unzip and move the binary:
   ```bash
   unzip terraform_*.zip
   sudo mv terraform /usr/local/bin/
   ```

</details>

<details>
<summary><strong>Windows</strong></summary>

**Option A — Winget (Windows 10/11, recommended)**
```powershell
winget install HashiCorp.Terraform
```

**Option B — Chocolatey**
```powershell
choco install terraform
```

**Option C — Manual download**
1. Go to https://developer.hashicorp.com/terraform/downloads
2. Download the **Windows AMD64** zip file
3. Unzip the `terraform.exe` file
4. Move it to a folder that is in your `PATH` (e.g., `C:\Windows\System32`)

> **Tip:** After installation, open a **new** PowerShell or Command Prompt window.

</details>

<details>
<summary><strong>Linux (Ubuntu / Debian)</strong></summary>

```bash
# Add HashiCorp GPG key and repo
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Install Terraform
sudo apt update && sudo apt install terraform
```

</details>

**Verify installation:**
```bash
terraform -version
# Expected output: Terraform v1.x.x
```

---

### Step 2 · Install the AWS CLI

<details>
<summary><strong>macOS</strong></summary>

```bash
# Option A — Homebrew
brew install awscli

# Option B — Official installer
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

</details>

<details>
<summary><strong>Windows</strong></summary>

```powershell
# Option A — Winget
winget install Amazon.AWSCLI

# Option B — Official MSI installer
# Download from: https://awscli.amazonaws.com/AWSCLIV2.msi
# Double-click the .msi and follow the installer
```

</details>

<details>
<summary><strong>Linux (Ubuntu / Debian)</strong></summary>

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

</details>

**Verify installation:**
```bash
aws --version
# Expected output: aws-cli/2.x.x ...
```

---

### Step 3 · Set Up Your IAM Account on AWS

> Your instructor will create an IAM user for you in the shared AWS account.
> You will receive an **Access Key ID** and a **Secret Access Key**.

What the instructor needs to do in AWS Console:
1. Go to **IAM → Users → Create user**
2. Give the user a name like `bootcamp-student-yourname`
3. Attach the policy `AmazonS3FullAccess`
4. Go to **Security credentials → Create access key → CLI**
5. Download or copy the **Access Key ID** and **Secret Access Key**

> **Security note:** Never share your keys publicly. Never commit them to Git.

---

### Step 4 · Configure the AWS CLI

Run the following command in your terminal and enter the credentials your instructor gave you:

```bash
aws configure
```

You will be prompted for:

| Prompt | Value |
|---|---|
| AWS Access Key ID | *(from your instructor)* |
| AWS Secret Access Key | *(from your instructor)* |
| Default region name | `ap-southeast-1` *(Singapore)* |
| Default output format | `json` |

**Verify your credentials work:**
```bash
aws sts get-caller-identity
```

Expected output (your Account ID will be different):
```json
{
    "UserId": "AIDAXXXXXXXXXXXXXXXXX",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/bootcamp-student-yourname"
}
```

---

## Part 2 — Get the Project Files

### Step 5 · Clone This Repository

```bash
git clone https://github.com/<your-org>/gusto_college_innovation_bootcamp_2026.git
cd gusto_college_innovation_bootcamp_2026
```

Or if you downloaded the ZIP file, unzip it and open a terminal in the project folder.

---

## Part 3 — Deploy the Website to AWS S3

### Step 6 · Create Your Terraform Variables File

```bash
# Go into the terraform directory
cd terraform

# Copy the example file
cp terraform.tfvars.example terraform.tfvars
```

Open `terraform.tfvars` in any text editor and **replace `YOUR-NAME`** with your own name:

```hcl
aws_region  = "ap-southeast-1"
bucket_name = "gusto-bootcamp-john-doe-2026"   # ← change this!
```

> **Important:** S3 bucket names are globally unique across all of AWS.
> If your name is already taken, add a random number, e.g. `gusto-bootcamp-john-doe-42`.

---

### Step 7 · Initialize Terraform

```bash
terraform init
```

This downloads the AWS provider plugin. You should see:

```
Initializing provider plugins...
- Installing hashicorp/aws v5.x.x...

Terraform has been successfully initialized!
```

---

### Step 8 · Preview the Changes

```bash
terraform plan
```

Terraform shows you exactly what it will create — **nothing is deployed yet**.

You should see `4 to add, 0 to change, 0 to destroy`.

---

### Step 9 · Deploy!

```bash
terraform apply
```

Type `yes` when prompted. After ~30 seconds you will see:

```
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

website_url = "http://gusto-bootcamp-john-doe-2026.s3-website-ap-southeast-1.amazonaws.com"
```

**Open the `website_url` in your browser — your site is live!** 🎉

---

## Part 4 — Modify the Website and Redeploy

This is the fun part. Make changes to the website and run `terraform apply` again
to see your updates go live instantly.

### Challenge 1 — Change the Headline

Open `website/index.html` and find this section:

```html
<h1 class="hero-title">
  Build &amp; Deploy<br />
  <span class="gradient-text">The Future</span><br />
  on AWS Cloud
</h1>
```

Change `The Future` to your own text, e.g. `My Dream`, then redeploy:

```bash
terraform apply -auto-approve
```

Refresh your browser and see your change live!

---

### Challenge 2 — Change the Button Color

Open `website/index.html` and find the demo button:

```html
<button id="demoBtn" ... data-color="blue" ...>
```

Change `data-color="blue"` to one of: `green`, `red`, `purple`, `blue`.

Redeploy and refresh to see the new color.

---

### Challenge 3 — Hide the Register Button

Open `website/index.html` and find:

```html
<button id="registerBtn" ... data-visible="true">Register Now</button>
```

Change `data-visible="true"` to `data-visible="false"`.

The **Register Now** button will disappear from the page after redeployment.

---

### Challenge 4 — Change the Version Tag

Open `website/script.js` and find:

```js
const VERSION = 'v1.0.0';
```

Change it to `'v2.0.0'` (or anything you like) and redeploy.
The version number in the footer will update.

---

### Challenge 5 — Change the Color Theme

Open `website/style.css` and find the `:root` block at the top:

```css
:root {
  --primary: #6366f1;      /* ← Change this to any hex color */
  --accent:  #f59e0b;
  --green:   #10b981;
  ...
}
```

Change `--primary` to a different color like `#e11d48` (red) or `#0ea5e9` (sky blue)
and redeploy. The entire site theme changes!

---

## Part 5 — Tear Down (Clean Up)

When you are done with the workshop, **destroy** all the AWS resources so you are
not charged:

```bash
terraform destroy
```

Type `yes` to confirm. All S3 objects and the bucket will be deleted.

---

## Quick Reference — Common Commands

| Task | Command |
|---|---|
| Check Terraform version | `terraform -version` |
| Check AWS identity | `aws sts get-caller-identity` |
| Initialize Terraform | `terraform init` |
| Preview changes | `terraform plan` |
| Deploy / redeploy | `terraform apply` |
| Deploy without confirmation | `terraform apply -auto-approve` |
| Destroy all resources | `terraform destroy` |
| Show outputs (URL) | `terraform output` |

---

## Troubleshooting

<details>
<summary><strong>Error: BucketAlreadyExists</strong></summary>

The bucket name is already taken globally. Open `terraform.tfvars` and pick a
more unique name, then run `terraform apply` again.

</details>

<details>
<summary><strong>Error: NoCredentialsError / Unable to locate credentials</strong></summary>

Run `aws configure` again and make sure you pasted the correct Access Key and
Secret Key. Then run `terraform apply` again.

</details>

<details>
<summary><strong>Error: AccessDenied</strong></summary>

Your IAM user may not have S3 permissions. Ask your instructor to attach the
`AmazonS3FullAccess` policy to your IAM user.

</details>

<details>
<summary><strong>Website shows "Access Denied" in browser</strong></summary>

Wait 1–2 minutes for the bucket policy to propagate, then refresh. If the issue
persists, run `terraform apply -auto-approve` to re-apply the policy.

</details>

<details>
<summary><strong>terraform: command not found</strong></summary>

The Terraform binary is not in your system PATH.
- **macOS/Linux:** Add `export PATH="$PATH:/usr/local/bin"` to your `~/.zshrc` or `~/.bashrc`, then reload: `source ~/.zshrc`
- **Windows:** Search for "Environment Variables" → add the folder containing `terraform.exe` to the `Path` variable.

</details>

---

## What You Learned

- How to install and configure **Terraform** and the **AWS CLI** on any OS
- How to create an **IAM user** and authenticate securely with access keys
- How to use Terraform to provision a **public S3 bucket** with static website hosting
- How to upload HTML, CSS, and JavaScript files to S3 automatically via Terraform
- How to make website changes and **redeploy in seconds** using `terraform apply`
- How to **tear down infrastructure** cleanly with `terraform destroy`

---

*Built with ❤️ by the GUSTO Team · College Innovation Bootcamp 2026*
