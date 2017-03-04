From: Jerry Snitselaar <dev@snitselaar.org>
Subject: Re: [PATCH v3 0/3] Locality support for tpm_crb
Date: Fri, 03 Mar 2017 18:27:19 -0700
Message-ID: <87efydvnk8.fsf@snitselaar.org>
References: <20170208111137.15153-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20170208111137.15153-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net


Jarkko Sakkinen @ 2017-02-08 11:11 GMT:

> The tpm_crb driver should follow the policy of reserving and
> relinquishing the locality it uses when multiple localities are used,
> like when TXT is another locality.
>
> [This is a resend of v3 as this has been asked from me for a few times
>  now and there wasn't anything obvious to fix.]
>
> Jarkko Sakkinen (3):
>   tpm_crb: map locality registers
>   tpm_crb: encapsulate crb_wait_for_reg_32
>   tpm_crb: request and relinquish locality 0
>
>  drivers/char/tpm/tpm_crb.c | 185 +++++++++++++++++++++++++++++++++------------
>  1 file changed, 137 insertions(+), 48 deletions(-)

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
