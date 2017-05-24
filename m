From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 2/5] tpm: introduce tpm_pcr_algo_to_crypto() and
 tpm_pcr_algo_from_crypto()
Date: Wed, 24 May 2017 13:25:23 -0700
Message-ID: <20170524202523.grpg7ocrwwuzxsbg@intel.com>
References: <20170505142152.29795-1-roberto.sassu@huawei.com>
 <20170505142152.29795-3-roberto.sassu@huawei.com>
 <20170515111629.urjvbhqzohv4vakc@intel.com>
 <0deed9be-d0c3-3a69-d510-1c8aa3513ba8@huawei.com>
 <20170520132217.t7n7l2pjn7i63hbm@intel.com>
 <0b04a33c-248b-6597-473f-c5bc4ccaba62@huawei.com>
 <20170524173354.puyulkjmio3jgs2l@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170524173354.puyulkjmio3jgs2l@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, May 24, 2017 at 10:33:54AM -0700, Jarkko Sakkinen wrote:
> On Mon, May 22, 2017 at 09:21:28AM +0200, Roberto Sassu wrote:
> > On 5/20/2017 3:22 PM, Jarkko Sakkinen wrote:
> > > On Mon, May 15, 2017 at 04:22:22PM +0200, Roberto Sassu wrote:
> > > > On 5/15/2017 1:16 PM, Jarkko Sakkinen wrote:
> > > > > On Fri, May 05, 2017 at 04:21:49PM +0200, Roberto Sassu wrote:
> > > > > > tpm_pcr_algorithms() returns to its callers the IDs of the hash algorithms
> > > > > > supported by the TPM. This patch introduces tpm_pcr_algo_to_crypto(),
> > > > > > so that the callers can use the crypto subsystem to calculate the digest
> > > > > > to be passed to tpm_pcr_extend().
> > > > > > 
> > > > > > tpm_pcr_algo_from_crypto(), implemented for completeness, is instead used
> > > > > 
> > > > > What do you mean by completeness? Please, never add unused stuff.
> > > > > 
> > > > > > by tpm2_seal_trusted() to perform the opposite conversion.
> > > > > > 
> > > > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > > ---
> > > > > > v2
> > > > > > 
> > > > > > - fixed return values of tpm2_pcr_algo_to_crypto() and
> > > > > >   tpm2_pcr_algo_from_crypto() if TPM support is disabled in the kernel
> > > > > 
> > > > > Change Log only to the cover letter.
> > > > > 
> > > > > >  drivers/char/tpm/tpm-interface.c | 51 ++++++++++++++++++++++++++++++++++++++++
> > > > > >  drivers/char/tpm/tpm2-cmd.c      | 42 +++++++++------------------------
> > > > > >  include/linux/tpm.h              | 13 ++++++++++
> > > > > >  3 files changed, 75 insertions(+), 31 deletions(-)
> > > > > 
> > > > > This commit is just deadly wrong in so many ways.
> > > > > 
> > > > > I would suggest to make extend always just take crypto ID in so you
> > > > > don't have to add these bizarre conversion functions.
> > > > 
> > > > The reason of this choice (as I explained in the cover letter)
> > > > is that TPM users might want to produce an event log with
> > > > the TCG format (which includes the TPM algorithm ID). Also,
> > > > TPM IDs should be preferred because, with them, TPM users
> > > > can calculate a digest directly with the TPM.
> > > > 
> > > > Taking crypto IDs means relying on the fact that there
> > > > is always a mapping between TPM IDs and crypto IDs.
> > > > Otherwise, tpm_pcr_algorithms() cannot return the algorithms
> > > > to its callers and PCRs cannot be extended. If TPM IDs are used,
> > > > TPM users have two alternatives: calculate the digest with
> > > > the TPM, or pass a SHA1 digest to tpm_pcr_extend(), so that
> > > > it can be padded to extend remanining PCR banks.
> > > > 
> > > > However, this second option will work only when the TPM driver
> > > > determines the size of an algorithm without relying on the crypto
> > > > subsystem. At the moment, if a TPM ID is not mapped to a crypto ID,
> > > > tpm2_pcr_extend() ignores the digest.
> > > > 
> > > > Roberto
> > > 
> > > What if tpm_pcr_algorithms would convert TPM IDs to crypto IDs?
> > > 
> > > Externally other subsystems would have to then deal with only crypto
> > > IDs.
> > 
> > Then, other subsystems cannot:
> > 
> > - use the TPM to calculate a digest
> > - create an event log with the TCG format
> > 
> > Roberto
> 
> Can you open this up a bit? What is the use case that you canno
> implement?
> 
> /Jarkko

The most important question is: are this used *right now*. If not, it is
a definitive NAK. We don't want any future-proof code to the kernel.
Always do the lowest common denominator in terms of generality and we
will refactor from there when need arises.

/Jarkko
