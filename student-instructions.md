# Deploying and Analyzing a Vulnerable Workload Using Sysdig

## Objective

In this lab, you will deploy a vulnerable application (**Pillow**) in a Kubernetes environment using an automated setup script. Once deployed, you will use Sysdig's vulnerability scanning capabilities to detect and analyze vulnerabilities within the **Pillow** pod. The lab will provide insights into identifying and mitigating security issues in containerized applications.

### Topics Covered:
- Deploying a vulnerable workload using `setup-script.sh`
- Installing and configuring Sysdig-CLI for vulnerability analysis
- Utilizing Sysdig-UI for vulnerability analysis
- Detecting and analyzing vulnerabilities in the Pillow pod

By the end of this lab, you will understand how to deploy vulnerable workloads and use Sysdig to identify security risks.

## Procedure

### Part 1: Deploying the Vulnerable Workload

1. Clone the Repository Containing the Deployment Script.

    `root@aserver:~#` `git clone https://github.com/BicycleWalrus/sysdig-assignment.git`

0. Change directory to access the setup script for this assignment.

    `root@aserver:~#` `cd sysdig-assignment/`

0. Make the Setup Script Executable.

    `root@aserver:~/sysdig-assignment#` `chmod +x setup-script.sh`

0. Run the Setup Script to deploy the **pillow** Pod.

    `root@aserver:~/sysdig-assignment#` `./setup-script.sh`

    > The script will create the necessary Kubernetes resources and deploy the vulnerable Pillow workload. The initialization requires approx 20 seconds.

0. Return to the home directory.

    `root@aserver:~/sysdig-assignment#` `cd`

0. Verify the Deployment.

    `root@aserver:~#`

    ```
    kubectl get pods
    kubectl get cm
    ```

    > Ensure the **pillow** pod is running. If not, troubleshoot the script output for errors.

### Part 2: Utilize Sysdig Secure to analyze vulnerabilities and exploits for Pillow

1. Open the **Sysdig Secure** application.

    &#128432; `Click 'Sysdig Secure' tab from the left panel of your learning Environment` - The **Sysdig Secure** UI opens in a new tab.

    > The Sysdig Secure dashboard displays metric data for Runtime Detections, and Vulnerabilities. Take some time to familiarize yourself before continuuing.

0. From the left sidebar, navigate to **Vulnerabilities > + Scan Now**

    &#128432; `Select 'Vulnerabilities > + Scan Now' from the left sidebar menu.` - The Runtime page opens.

0. From the left sidebar, navigate to **Vulnerabilities > Findings/Runtime**.

    &#128432; `Select 'Vulnerabilities > Findings/Runtime' from the left sidebar menu.` - The Runtime page opens.

    > There are an awful lot of failures being reported here, but finding our **pillow** pod/container is easy with the filter menu provided at the top of the page.

0. Setup the filter for our **pillow** pod/container.

    &#128432; `Click 'Add Filter' from the top of the page, and select 'kubernetes.pod.container.name'` - The **Filter Type** selection opens.

    &#128432; `Select '= is' from the drop-down menu'` - The **Enter Value** dialog box opens

    `Enter Value` `pillow`

    &#128432; `Select 'pillow' from the drop-down menu'` - The **default > pod:pillow > pillow** pod appears by itself in the menu.

0. Open the Runtime Vulnerabilities page for **pillow**.

    &#128432; `Click the 'vulhub/ghostscript > pillow' object from the menu.` - An overview of Vulnerabilities and Policy findings appears.

    > Review the page to determine what issues exist, from Vulnerabilities and Policies. It isn't uncommon to see quite a few results, especially when working with images available from public registries.

0. Take a moment to focus specifically on **Vulnerabilities** by opening the **Vulnerabilities** tab.

    &#128432; `Click the 'Vulnerabilities' Tab.` - An overview of Vulnerabilities and Policy findings appears.

    > We still have quite a few results, but let's see if there are any *exploitable* vulnerabilities. An **Exploit** indicates that there are known tools that attackers could use to leverage the vulnerability. We need to squash these.

0. From the Right Panel, select the **Has Exploit** filter.

    &#128432; `Select the 'Has Exploit' filter button from the right panel, under 'Severity By'` - All non-exploitable vulnerabilities are removed, and only **CVE-2023-4863** remains.

    > This is a **High** severity vulnerability with a known exploit. Luckily, you'll also notice the wrench is highlighted under the **CVE Context** tab. This means the exploit is fixable! But what is **CVE-2023-4863** anyways? Let's take a look at the [National Vulnerability Database](https://nvd.nist.gov/vuln/detail/CVE-2023-4863)! CVE-2023-4863 is a critical heap buffer overflow vulnerability in **libwebp**, a widely used library for encoding and decoding WebP images. This flaw allows remote attackers to execute arbitrary code by enticing users to open specially crafted WebP images, potentially leading to system compromise. 

0. No need to panic now, but we found a problem! What should we do to fix it? Sysdig makes it easy by providing **Recommendations**. Let's open that page now.

    &#128432; `Click the 'Recommendations' Tab.` - Detailed Recommendations open for your review.

    > The first recommendation is already open for your review. There are currently **39** vulnerabilities, including **9** critical and **21** High vulnerabilities that can be fixed by installing a new version of the **Pillow** package. By upgrading to version **v6.2.2**, we can resolve many of these security vulnerabilities.

0. But what about our Exploit? Open the corresponding recommendation for **Fix Vulnerability CVE-2023-4863**.

    &#128432; `Click the 'Fix Vulnerability CVE-2023-4863' button.` - Detailed instructions to fix the vulnerability opens for your review.

    > As we can see, we have a fix which involves an upgrade of **pillow** to version 10.0.1 to fix the exploitable vulnerability. As a general recommendation, you should ensure upgrades to relavent packages be updated periodically to account for these types of Vulnerabilities. 

## Conclusion

In this lab, you deployed a vulnerable workload (Pillow) using a setup script and used Sysdig to analyze vulnerabilities within the workload. You learned how to identify risks and extract insights from container logs and reports, highlighting the importance of securing containerized environments. This lab demonstrates how automated tools like Sysdig can simplify the vulnerability management process and aid in mitigating potential risks.
