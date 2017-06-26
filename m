From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [Linux-ima-devel] [PATCH v3 0/6] Updated API for TPM 2.0 PCR
 extend
Date: Mon, 26 Jun 2017 13:12:15 -0400
Message-ID: <1498497135.3387.69.camel@linux.vnet.ibm.com>
References: <20170621142941.32674-1-roberto.sassu@huawei.com>
         <20170624090325.kbqhwkrx5qvtxveg@linux.intel.com>
         <1498480439.3387.45.camel@linux.vnet.ibm.com>
         <03e70c05-5127-5c95-de8b-fedf90a23d7e@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <03e70c05-5127-5c95-de8b-fedf90a23d7e@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, Kenneth Goldman <kgoldman@us.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2017-06-26 at 16:56 +0200, Roberto Sassu wrote:
> On 6/26/2017 2:33 PM, Mimi Zohar wrote:
> > On Sat, 2017-06-24 at 11:03 +0200, Jarkko Sakkinen wrote:
> >> On Wed, Jun 21, 2017 at 04:29:35PM +0200, Roberto Sassu wrote:
> >
> >
> >> To move this forward and be more constructive here's how I see it
> >> should be done (along the lines, draft):
> >>
> >> int tpm_pcr_extend(u32 chip_num, int pcr_idx, unsigned int alg,
> >> 		   const u8 *hash);
> >>
> >> The paramater 'alg' is crypto ID as specified by crypto subsystem.
> >
> > Based on Kenneth Goldman's input, the new IMA TPM-2.0 crypto hash
> > agile measurement list will contain the TPM crypto hash algorithm ids
> > (TPM crypto-ID).
> >
> >> TPM driver must have a precompiled table of mappings for crypto IDs
> >> and TPM algorithm IDs.
> >
> > We could map the TPM crypto-IDs to the crypto subsystem IDs and then
> > map them back, but is that necessary?
> >
> >>
> >> In addition it must have dynamically acquired list of TPM alg IDs.
> >> For those algs that static mapping does not exist it must extend
> >> them like we do now everything else except SHA-1 (Naynas changes).
> >
> > Padding/truncating an unknown bank using SHA1 is fine, but at some
> > point, as Roberto pointed out to me, TPM 2.0's might not support SHA-
> > 1.  So for the record, we're hard coding the use of SHA1 for the
> > unknown algorithms whether or not the TPM supports SHA1.
> 
> This solution requires that SHA1 digests are always calculated
> and included in the event log, even if SHA1 has not been selected
> by the user. I think this is not acceptable in the scenarios where
> saving power and memory is important.
> 
> I would instead use the first digest passed to tpm_pcr_extend()
> (it must be the first also in the event log) to extend banks
> for which the digest is missing.

As long as we don't break the existing userspace/kernel IMA
measurement list ABI, then I'm Ok with this.

Mimi

> If TPM users want to pad/truncate a different digest, they can
> pass to tpm_pcr_extend() a digest for each TPM algorithm.
> This is possible with the patches I sent because TPM users
> receive the TPM algorithm IDs and the digest size for each
> algorithm.
> 
> Regarding the possibility that SHA1 could not be supported,
> for now this shouldn't happen because, according to TCG,
> SHA1 support is mandatory for TPM 2.0:
> 
> https://trustedcomputinggroup.org/wp-content/uploads/TCG_Algorithm_Registry_Rev_1.24.pdf
> 
> I don't know if SHA1 can be marked as Legacy in a next
> revision of the document.
> 
> Roberto
> 
> 
> >> There's absolutely no need to pass digest size like you do BTW as it is
> >> defined by the standard.
> >
> > For algorithms known to the crypto subsystem, that is fine, but for
> > the unknown TPM crypto algorithms, we would need to somehow query the
> > TPM for the digest sizes to create the mapping.
> >
> > Mimi
> >
> >> I also except that where ever this interleaves with trusted keys there
> >> won't be duplicate structures and code.
> >>
> >> /Jarkko
> >>
> >
> 

