From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: remove chip_num parameter from
 in-kernel API
Date: Tue, 24 Oct 2017 16:04:15 +0200
Message-ID: <20171024140415.wx6oyqpktbebjt25@linux.intel.com>
References: <20171023123817.18559-1-jarkko.sakkinen@linux.intel.com>
 <cbcb78c6-fa36-32d3-891e-96544875d97c@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cbcb78c6-fa36-32d3-891e-96544875d97c@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: linux-integrity@vger.kernel.org, David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, "open list:INTEGRITY MEASUREMENT ARCHITECTURE IMA" <linux-ima-user@lists.sourceforge.net>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, open list <linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-security-module@vger.kernel.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, "open list:KEYS-TRUSTED" <keyrings@vger.kernel.org>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, James Morris <james.l.morris@oracle.com>, Matt Mackall <mpm@selenic.com>, "open list:INTEGRITY MEASUREMENT ARCHITECTURE IMA" <linux-ima-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Oct 23, 2017 at 10:07:31AM -0400, Stefan Berger wrote:
> I think every kernel internal TPM driver API should be called with the
> tpm_chip as a parameter. This is in foresight of namespacing of IMA where we
> want to provide the flexibility of passing a dedicated vTPM to each
> namespace and IMA would use the chip as a parameter to all of these
> functions to talk to the right tpm_vtpm_proxy instance. From that
> perspective this patch goes into the wrong direction.
> 
>    Stefan

The goal of this patch is to kernel code that never gets executed. It
removes a load of completely dead code. It is the only thing that this
commit does. Why do you think this is "going into wrong direction" if it
only removes dead code and refines the documentation up to date?

After the dead code has been removed it makes sense to propose a better
mechanism. Maybe the one that you are speaking about. But you need to
remove the cruft first.

/Jarkko
