From: Javier Martinez Canillas <javierm@redhat.com>
Subject: Re: [tpmdd-devel] [PATCH v2 0/3] Call GetEventLog before
 ExitBootServices
Date: Thu, 14 Sep 2017 12:21:59 +0200
Message-ID: <5d530df3-7a7a-4cd7-bde6-92f733c7ae75@redhat.com>
References: <20170911100022.7251-1-tweek@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170911100022.7251-1-tweek@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thiebaud Weksteen <tweek@google.com>, linux-efi@vger.kernel.org
Cc: ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk, linux-kernel@vger.kernel.org, mjg59@google.com, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, jarkko.sakkinen@linux.intel.com, Peter Jones <pjones@redhat.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Hello Thiebaud,

On 09/11/2017 12:00 PM, Thiebaud Weksteen via tpmdd-devel wrote:
> With TPM 1.2, the ACPI table ("TCPA") has two fields to recover the Event Log
> Area (LAML and LASA). These logs are useful to understand and rebuild the
> final values of PCRs.
> 
> With TPM 2.0, the ACPI table ("TPM2") does not contain these fields anymore.
> The recommended method is now to call the GetEventLog EFI protocol before
> ExitBootServices.
> 
> Implement this method within the EFI stub and create copy of the logs for the
> TPM device. This will create /sys/kernel/security/tpm0/binary_bios_measurements
> for TPM 2.0 devices (similarly to the current behaviour for TPM 1.2 devices).
> 

I've tested your patches on a system with an Intel PTT firmware based TPM2.0 and
the measurements securityfs entry was correctly created and was able to read it:

$ cat /sys/class/tpm/tpm0/device/description
TPM 2.0 Device

$ hexdump /sys/kernel/security/tpm0/binary_bios_measurements | head -n2
0000000 0000 0000 0008 0000 f504 15a0 1810 bf44
0000010 63d0 4fdb b8a4 f278 8dc7 c8aa 0014 0000

So please feel free to add:

Tested-by: Javier Martinez Canillas <javierm@redhat.com>

I also reviewed the patches and look good to me, I have just one question for
patch #2, but I'll comment there.

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
