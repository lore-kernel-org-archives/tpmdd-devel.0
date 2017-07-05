From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [Linux-ima-devel] [PATCH v3 0/6] Updated API for
 TPM 2.0 PCR extend
Date: Wed, 05 Jul 2017 12:06:42 -0400
Message-ID: <1499270802.3059.101.camel@linux.vnet.ibm.com>
References: <20170621142941.32674-1-roberto.sassu@huawei.com>
         <20170624090325.kbqhwkrx5qvtxveg@linux.intel.com>
         <1498480439.3387.45.camel@linux.vnet.ibm.com>
         <20170628172851.fuap4ennmdj473yu@linux.intel.com>
         <55cf0a07-bee8-a034-4d40-6232bc0eefb8@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55cf0a07-bee8-a034-4d40-6232bc0eefb8@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ken Goldman <kgold@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, keyrings@vger.kernel.org, linux-ima-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 2017-07-05 at 11:18 -0400, Ken Goldman wrote:
> On 6/28/2017 1:28 PM, Jarkko Sakkinen wrote:
>  > On Mon, Jun 26, 2017 at 08:33:59AM -0400, Mimi Zohar wrote:
>  >> On Sat, 2017-06-24 at 11:03 +0200, Jarkko Sakkinen wrote:
>  >>> On Wed, Jun 21, 2017 at 04:29:35PM +0200, Roberto Sassu wrote:

>  >>> There's absolutely no need to pass digest size like you do BTW as 
> it >>> is defined by the standard.
>  >>
>  >> For algorithms known to the crypto subsystem, that is fine, but for
>  >> the unknown TPM crypto algorithms, we would need to somehow query the
>  >> TPM for the digest sizes to create the mapping.
>  >>
>  >> Mimi
>  >
>  > There's a TPM command to query TPM algorithms.
> 
> This is true - one getcap to determine the number of algorithms, then a 
> pcr read, then parse the response structures and match the algorithms to 
> sizes.
> 
> Alternatively, could you create a table mapping the algorithm to the 
> size?  There are currently 8 approved algorithms, meaning the table is 
> 32 bytes, probably less code than the queries.
> 
> As for an algorithm appearing in the TPM that's not in the table, it 
> takes a year or more for a new algorithm to appear.  Is that enough time 
> to patch the device driver?
> 
> FYI, the 8 algorithms are:
> 
> sha1, sha256, sha384, sha512, sm3-256, sha3-256, sha3-384, sha3-512.
> 
> I am only aware of sha1, sha256, and sm3-256 being used in production 
> hardware TPMs.

New devices aren't being shipped with the most recent kernels.  So
even if the upstream kernel supports the newer crypto algorithms, that
doesn't imply that it is available.

A safer method would be to query the TPM for the digest sizes.

Mimi
