From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: remove chip_num parameter from
 in-kernel API
Date: Mon, 23 Oct 2017 10:31:39 -0600
Message-ID: <20171023163139.GA17394@obsidianresearch.com>
References: <20171023123817.18559-1-jarkko.sakkinen@linux.intel.com>
 <cbcb78c6-fa36-32d3-891e-96544875d97c@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cbcb78c6-fa36-32d3-891e-96544875d97c@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-integrity@vger.kernel.org, David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, "open list:INTEGRITY MEASUREMENT ARCHITECTURE IMA" <linux-ima-user@lists.sourceforge.net>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, "open list:KEYS-TRUSTED" <keyrings@vger.kernel.org>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, James Morris <james.l.morris@oracle.com>, Matt Mackall <mpm@selenic.com>, "open list:INTEGRITY MEASUREMENT ARCHITECTURE IMA" <linux-ima-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Oct 23, 2017 at 10:07:31AM -0400, Stefan Berger wrote:

> >-int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
> >+int tpm_pcr_extend(int pcr_idx, const u8 *hash)
> >  {
> 
> 
> I think every kernel internal TPM driver API should be called with the
> tpm_chip as a parameter. This is in foresight of namespacing of IMA where we
> want to provide the flexibility of passing a dedicated vTPM to each
> namespace and IMA would use the chip as a parameter to all of these
> functions to talk to the right tpm_vtpm_proxy instance. From that
> perspective this patch goes into the wrong direction.

Yes, we should ultimately try and get to there.. Someday the
tpm_chip_find_get() will need to become namespace aware.

But this patch is along the right path, eliminating the chip_num is
the right thing to do..

> >-	tpm2 = tpm_is_tpm2(TPM_ANY_NUM);
> >+	tpm2 = tpm_is_tpm2();
> >  	if (tpm2 < 0)
> >  		return tpm2;
> >
> >@@ -1008,7 +1007,7 @@ static int trusted_instantiate(struct key *key,
> >  	switch (key_cmd) {
> >  	case Opt_load:
> >  		if (tpm2)
> >-			ret = tpm_unseal_trusted(TPM_ANY_NUM, payload, options);
> >+			ret = tpm_unseal_trusted(payload, options);

Sequences like this are sketchy.

It should be

struct tpm_chip *tpm;

tpm = tpm_chip_find_get()
tpm2 = tpm_is_tpm2(tpm);

[..]

if (tpm2)
     ret = tpm_unseal_trusted(tpm, payload, options);

[..]

tpm_put_chip(tpm);

As hot plug could alter the 'tpm' between the two tpm calls.

Jason
