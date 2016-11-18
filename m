From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 2/2] tpm: refactor tpm2_get_tpm_pt to
 tpm2_getcap_cmd
Date: Fri, 18 Nov 2016 08:13:51 -0800
Message-ID: <20161118161224.7sq4dbcnyzumbvds@intel.com>
References: <1476008057-2395-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1476008057-2395-3-git-send-email-jarkko.sakkinen@linux.intel.com>
 <58254759.80406@linux.vnet.ibm.com>
 <20161112000242.63hgv5ujmkr7hy6a@intel.com>
 <582D998C.40605@linux.vnet.ibm.com>
 <20161117174241.wvyd7g5lj4ibfnry@intel.com>
 <582EF011.1050007@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <582EF011.1050007@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nayna <nayna@linux.vnet.ibm.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Nov 18, 2016 at 05:42:01PM +0530, Nayna wrote:
> 
> 
> On 11/17/2016 11:12 PM, Jarkko Sakkinen wrote:
> > On Thu, Nov 17, 2016 at 05:20:36PM +0530, Nayna wrote:
> > 
> > > I tested this for capability TPM2_CAP_PCRS. It seems TPM2_CAP_PCRS
> > > capability always returns full PCR allocation, and more_data as 0, So, I
> > > think the idea of looping over based on more_data may not work for this
> > > capability.
> > 
> > You can always request one value at a time until there's no more.
> > 
> > If you request N values, depending on the hardware, the hardware returns
> > to you anything from 1 to N values. If you implement a function that
> > requests N values in the command, you *must* handle the case where
> > moreData is 1 even if the hardware you are testing that never happens.
> > 
> > That's the reason why I would start with a function that you request one
> > property of one capability and optimize it in future if it doesn't scale
> > for some workload.
> > 
> > Do you have a workload where it doesn't scale?
> 
> Thanks Jarkko for explaining in detail.
> 
> If I understood correctly, the idea is to request for one property at a
> time, and if we need multiple properties, then to request for each of them
> in a loop. In case of TPM2_CAP_PCRS, property is always zero. This is how I
> am calling getcap_cmd for TPM2_CAP_PCRS.
> 
> tpm2_getcap_cmd(chip, TPM2_CAP_PCRS, 0, &cap_data, "get active pcr banks");
> 
> Output :
> 
> [   17.081665] tpm: cap id to receive value is 2
> [   17.081666] tpm: TPM2_CAP_COMMANDS: more data 1
> [   17.081667] tpm: 2
> [   17.081668] tpm: tpm2_get_active_banks  -------> cap is TPM2_CAP_PCRS
> [   17.171665] tpm: cap id to receive value is 5
> [   17.171666] tpm: TPM2_CAP_PCRS: more data 0 ---> more data is zero.
> [   17.171666] tpm: TPM2_CAP_PCRS: more data 0
> [   17.171667] tpm: count pcr banks is 2 ------> count of active pcr banks
> information returned
> 
> more_data is always zero here, so am not sure how to handle more_data in
> this case ?
> Since property_id is always zero, I am not able to request for one property
> at a time.
> and response_buffer returns the details for both active banks.
> 
> This is the expected behavior defined in TCG 2.0 Part 3 Commands
> Specification (Section 30.2.1):
> 
> "TPM_CAP_PCRS – Returns the current allocation of PCR in a
> TPML_PCR_SELECTION. The property parameter shall be zero. The TPM will
> always respond to this command with the full PCR allocation and moreData
> will be NO."
> 
> Please let me know, if I am missing something.

Thanks for pointing that. I think you got it right and I had some wrong
assumptions about 'moreData'.

Here's what I propose. Do a non-generic function just for getting CAP_PCRS.
You could call it tpm2_get_pcr_allocation() as you don't want or rather
need to handle all the bells and whistles in that TPM command.

It makes a lot more sense now than having one-size-for-all function.

/Jarkko
