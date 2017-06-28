From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [Linux-ima-devel] [PATCH v3 0/6] Updated API for TPM 2.0 PCR
 extend
Date: Wed, 28 Jun 2017 20:28:51 +0300
Message-ID: <20170628172851.fuap4ennmdj473yu@linux.intel.com>
References: <20170621142941.32674-1-roberto.sassu@huawei.com>
 <20170624090325.kbqhwkrx5qvtxveg@linux.intel.com>
 <1498480439.3387.45.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1498480439.3387.45.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Roberto Sassu <roberto.sassu@huawei.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, Kenneth Goldman <kgoldman@us.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jun 26, 2017 at 08:33:59AM -0400, Mimi Zohar wrote:
> On Sat, 2017-06-24 at 11:03 +0200, Jarkko Sakkinen wrote:
> > On Wed, Jun 21, 2017 at 04:29:35PM +0200, Roberto Sassu wrote:
> 
> 
> > To move this forward and be more constructive here's how I see it
> > should be done (along the lines, draft):
> > 
> > int tpm_pcr_extend(u32 chip_num, int pcr_idx, unsigned int alg,
> > 		   const u8 *hash);
> > 
> > The paramater 'alg' is crypto ID as specified by crypto subsystem.
> 
> Based on Kenneth Goldman's input, the new IMA TPM-2.0 crypto hash
> agile measurement list will contain the TPM crypto hash algorithm ids
> (TPM crypto-ID). 

Doesn't this lock you to TPM? 

If you seriously want to do this, I guess it is fine by me but I'm just
wondering why the measurement list couldn't use something with more
loose binding to TPM.

> > TPM driver must have a precompiled table of mappings for crypto IDs
> > and TPM algorithm IDs.
> 
> We could map the TPM crypto-IDs to the crypto subsystem IDs and then
> map them back, but is that necessary?
> 
> > 
> > In addition it must have dynamically acquired list of TPM alg IDs.
> > For those algs that static mapping does not exist it must extend
> > them like we do now everything else except SHA-1 (Naynas changes).
> 
> Padding/truncating an unknown bank using SHA1 is fine, but at some
> point, as Roberto pointed out to me, TPM 2.0's might not support SHA-
> 1.  So for the record, we're hard coding the use of SHA1 for the
> unknown algorithms whether or not the TPM supports SHA1.

Why doesn't it work to pick algorithm X from the availabe options and
do truncation/padding for that? Not necessarily SHA1.

> 
> > There's absolutely no need to pass digest size like you do BTW as it is
> > defined by the standard.
> 
> For algorithms known to the crypto subsystem, that is fine, but for
> the unknown TPM crypto algorithms, we would need to somehow query the
> TPM for the digest sizes to create the mapping.
> 
> Mimi

There's a TPM command to query TPM algorithms.

/Jarkko
