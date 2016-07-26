From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Regarding recently Added TPM2.0 support to the
	Nuvoton i2c driver
Date: Tue, 26 Jul 2016 23:44:43 +0530
Message-ID: <5797A893.9020205@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: David Heller <hellerda-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, George Wilson <gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Hi

I might not be aware of some background related to TPM device driver 
design and so have got few questions regarding recently added support in 
Nuvoton i2c driver for TPM2.0 
(http://git.infradead.org/users/jjs/linux-tpmdd.git/commit/82cc1a49b6358394938e759dc4c22b2be773bbad). 
I got these questions while testing some TPM2.0 stuff using the kernel 
code from repo having this patch and am using Nuvoton TPM.

#1. It seems that support is added only for following device-ids.
         {.compatible = "nuvoton,npct501"},
         {.compatible = "winbond,wpct301"},
         {.compatible = "nuvoton,npct601", .data = OF_IS_TPM2},

So, was wondering about why device id nuvoton,npct650  wasn't added for 
the support ?

Was it expected to work with some wild-card type device-id as specified 
in the first line of description comment of file i.e. npct6XX. ?
/**
* Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501/NPCT6XX,
........
**/

Also, the patch log message says "tpm: Add TPM 2.0 support to the 
Nuvoton i2c driver (NPCT6xx family)" i.e. NPCT6xx family, so my 
assumption was that it will work with any NPCT6xx device id.

#2 Was also trying to understand why the .data is hardcoded for 
nuvoton,npct601, but not for other device ids ?

And I see that this device-id .data info is then used in 
i2c_nuvoton_probe() method to set the tpm_chip flag as TPM2 device
        if (dev->of_node) {
                 const struct of_device_id *of_id;
                 printk("dev->of_node if\n");
                 of_id = of_match_device(dev->driver->of_match_table, dev);
                 if (of_id && of_id->data == OF_IS_TPM2)
                 {
                         printk("of_id->data == OF_IS_TPM2\n");
                         chip->flags |= TPM_CHIP_FLAG_TPM2;
                 }
         } else
         {
                 printk("dev->of_node else\n");
                 if (id->driver_data == I2C_IS_TPM2)
                 {

                         printk("id->driver_data == I2C_IS_TPM2\n");
                         chip->flags |= TPM_CHIP_FLAG_TPM2;
                 }
         }


So, why is there hard-coded checking and not using tpm2_probe() method 
which is itself based on direct TPM hardware response for setting the 
TPM2 flag. ? Is there something I am missing in the design which 
mandates to have .data set as OF_IS_TPM2.

Please let me know.


Thanks & Regards,
    - Nayna


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
