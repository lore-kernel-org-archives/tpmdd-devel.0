From: Ken Goldman <kgoldman@us.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v2 3/5] tpm: infrastructure for TPM
 spaces
Date: Sat, 14 Jan 2017 12:53:15 -0500
Message-ID: <o5dohv$60l$1@blaine.gmane.org>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
 <20170112174612.9314-4-jarkko.sakkinen@linux.intel.com>
 <1484253532.5807.16.camel@linux.vnet.ibm.com>
 <20170113162855.dddgsomp7m4c3inc@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170113162855.dddgsomp7m4c3inc@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: linux-security-module@vger.kernel.org
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 1/13/2017 11:28 AM, Jarkko Sakkinen wrote:

>>> +
>>> +       if (!tpm2_find_cc_attrs(chip, cc, &attrs)) {
>>> +               /* should never happen */
>>> +               dev_err(&chip->dev, "TPM returned a different CC:
>>> 0x%04x\n",
>>> +                       cc);
>>> +               rc = -EFAULT;
>>> +               goto out_err;
>>> +       }

Something is strange here.  Is "CC" command code?

The TPM does not return a command code.  The mapping should use the
command code from the command.

It could be the code is correct - the command code mapped OK in the 
command but then failed in the response.  But the error message is strange.


