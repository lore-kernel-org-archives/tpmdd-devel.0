From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] vTPM: fix missing error handling for suspend operation
Date: Thu, 31 Mar 2016 09:42:29 -0700
Message-ID: <20160331164229.GA16413@kroah.com>
References: <1459435283-1163-1-git-send-email-honclo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459435283-1163-1-git-send-email-honclo@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: "Hon Ching(Vicky) Lo" <honclo@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <PeterHuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Mar 31, 2016 at 10:41:23AM -0400, Hon Ching(Vicky) Lo wrote:
> ibmvtpm_send_crq in tpm_ibmvtpm_suspend returns errors in a more
> granular level than what the existing code does.  This patch adds
> the missing CRQ transport event code checks to ensure appropriate
> action taken, in the case that ibmvtpm_send_crq returns H_CLOSED.
> 
> Signed-off-by: Hon Ching(Vicky) Lo <honclo@linux.vnet.ibm.com>
> ---
>  drivers/char/tpm/tpm_ibmvtpm.c |   43 ++++++++++++++++++++++++++++++++++++---
>  drivers/char/tpm/tpm_ibmvtpm.h |    7 ++++++
>  2 files changed, 46 insertions(+), 4 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
