From: Ken Goldman <kgold@linux.vnet.ibm.com>
Subject: Re: Aw: Re: [tpmdd-devel] [PATCH] tpm: improve tpm_tis send()
 performance by ignoring burstcount
Date: Wed, 16 Aug 2017 15:51:43 -0400
Message-ID: <4eac8afa-89ff-fa02-05ba-a5c1018351af@linux.vnet.ibm.com>
References: <20170807114632.1339-1-nayna@linux.vnet.ibm.com>
 <E37DFCB0-2E74-45F6-B2DF-70EF59F310BC@gmx.de>
 <20170808191145.kggmoczd5laiccrn@linux.intel.com>
 <819e3d38-3f16-a32b-1928-c425b763d5f8@linux.vnet.ibm.com>
 <trinity-56ff4f3f-5e08-4aac-9353-a7b88fe91f01-1502311387207@3c-app-gmx-bs76>
 <b8693dd5-7c28-f8f0-fa27-1f204ef7e64c@linux.vnet.ibm.com>
 <20170814101046.5hqrkaqmfvl7ugwj@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170814101046.5hqrkaqmfvl7ugwj@linux.intel.com>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 8/14/2017 6:10 AM, Jarkko Sakkinen wrote:
>> Nuvoton, ST Micro, and Infineon confirmed that the TPM empties a byte from
>> the FIFO in under 1 usec.  So, even with a static burst count, the entire
>> FIFO would empty in under 10 usec.
> 
> Does this break anything lets say in a decade time frame? If it does, I
> will not even consider this. Can you give a definitive answer for that?

My attempt at predicting the future ...

1 - Clock speed should get faster, not slower, so the 1 usec wait state 
should get shorter.

2 - TPM buffers should get larger.  I'm already reading of 256 byte 
buffers.  So there should be fewer wait states.

3 - There is a trend toward using the CRB, making the FIFO less applicable.

4 - There is a trend away from LPC connected serial port devices, 
printers, and PS/2 mouse and keyboard, and toward USB connected devices. 
  I assume this will continue, making the already insignificant wait 
states irrelevant.

