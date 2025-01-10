# Detecting and Analyzing a Vulnerable Workload Using Sysdig Secure

## Objective

In this lab, students will learn how to use Sysdig Secure to identify and analyze vulnerabilities in containerized workloads. By working through this hands-on exercise, participants will gain a deeper understanding of securing workloads by scanning container images, and detecting runtime vulnerabilities. The primary objectives include:

- Using Sysdig Secure to perform an image scan and identify vulnerabilities.
- Detecting runtime vulnerabilities and analyzing their impact.
- Understanding and applying remediation strategies for identified vulnerabilities.

This lab provides practical experience in using Sysdig Secure to strengthen containerized application security.

## Procedure

### Part 1: Performing an Image Scan using Sysdig Secure

1. Open the **Sysdig Secure** application.

    &#128432; `Click 'Sysdig Secure' tab from the left panel of your learning Environment` - The **Sysdig Secure** UI opens in a new tab.

0. Log in to Sysdig Secure using the provided credentials.

    > The Sysdig Secure dashboard displays metric data for Runtime Detections, and Vulnerabilities. Take some time to familiarize yourself before continuuing.

0. From the left sidebar, navigate to **Vulnerabilities > + Scan Now**

    &#128432; `Select 'Vulnerabilities > + Scan Now' from the left sidebar menu.` - The Scan Image dialog form opens.

0. The image we'll be using for our vulnerable workload later on in the lab is **vulhub/ghostscript:9.23-with-flask**. We'll need to scan this image in order for Sysdig to detect vulnerabilities at Runtime. Complete the **Scan Image** dialog form as follows.

    `Please enter your image reference to scan it directly from the registry` `vulhub/ghostscript:9.23-with-flask`

    &#128432; `Click the 'Scan Image' button.` - The Image Scan will initiate.

    &#128432; `Click the 'See the Queue' button.` - The Registry > Scan the Queue page will open.

0. You'll see that our image was scanned. Let's read the details of our image scan!

    &#128432; `Click the 'index.docker.io/vulhub/ghostscript' list object.` - The **index.docker.io/vulhub/ghostscript** page will open.

0. Here, we can learn all sorts of things about our image. **It is a Best Practice** to scan images prior to running them on a container, in any environment.

    > Nothing to do here for now! We'll see this page later on. Let's move on scanning vulnerabilities at runtime!

### Part 2: Deploying the Vulnerable Workload

> Return to the Terminal Window to begin

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

    > It takes roughly 35 seconds for the Pod to initialize. Ensure the **pillow** pod is running before continuing.

### Part 3: Detecting a Vulnerable Workload at Runtime

> Return to the Sysdig Secure window to begin.

1. From the left sidebar, navigate to **Vulnerabilities > Findings/Runtime**.

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

    > We still have quite a few results, but let's see if there are any *exploitable* vulnerabilities. An **Exploit** indicates there are known tools attackers could use to leverage the vulnerability. We need to squash these.

0. From the Right Panel, select the **Has Exploit** filter.

    &#128432; `Select the 'Has Exploit' filter button from the right panel, beneath 'Severity By'` - All non-exploitable vulnerabilities are removed, and only **CVE-2023-4863** remains.

    > This is a **High** severity vulnerability with a known exploit. Luckily, you'll also notice the wrench is highlighted under the **CVE Context** tab. This means the exploit is fixable! But what is **CVE-2023-4863** anyways? Let's take a look at the [National Vulnerability Database](https://nvd.nist.gov/vuln/detail/CVE-2023-4863)! CVE-2023-4863 is a critical heap buffer overflow vulnerability in **libwebp**, a widely used library for encoding and decoding WebP images. This flaw allows remote attackers to execute arbitrary code by enticing users to open specially crafted WebP images, potentially leading to system compromise. 

0. No need to panic now, but we found a problem! What should we do to fix it? Sysdig makes it easy by providing **Recommendations**. Let's open that page now.

    &#128432; `Click the 'Recommendations' Tab.` - Detailed Recommendations open for your review.

    > The first recommendation is already open for your review. There are currently **39** vulnerabilities, including **9** critical and **21** High vulnerabilities that can be fixed by installing a new version of the **Pillow** package. By upgrading to version **v6.2.2**, we can resolve these security vulnerabilities.

0. But what about our Exploit? Open the corresponding recommendation for **Fix Vulnerability CVE-2023-4863**.

    &#128432; `Click the 'Fix Vulnerability CVE-2023-4863' button.` - Detailed instructions to fix the vulnerability opens for your review.

    > As we can see, we have a fix which involves an upgrade of **pillow** to version 10.0.1 to fix the exploitable vulnerability. As a general recommendation, you should ensure upgrades to relavent packages are performed periodically to account for these types of Vulnerabilities. 

## Conclusion

In this lab, you explored how to use Sysdig Secure for identifying and remediating vulnerabilities in containerized workloads. By scanning images before deployment, detecting runtime vulnerabilities, and applying recommended fixes, you gained hands-on experience with container security best practices. The lab demonstrated how to identify critical vulnerabilities, like CVE-2023-4863, and take actionable steps to resolve them, emphasizing the importance of proactive security measures in modern cloud-native environments.
