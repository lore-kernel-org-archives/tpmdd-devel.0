From: Ken Goldman <kgold@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [Linux-ima-devel] [PATCH v3 0/6] Updated API for
 TPM 2.0 PCR extend
Date: Wed, 5 Jul 2017 11:18:54 -0400
Message-ID: <55cf0a07-bee8-a034-4d40-6232bc0eefb8@linux.vnet.ibm.com>
References: <20170621142941.32674-1-roberto.sassu@huawei.com>
 <20170624090325.kbqhwkrx5qvtxveg@linux.intel.com>
 <1498480439.3387.45.camel@linux.vnet.ibm.com>
 <20170628172851.fuap4ennmdj473yu@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170628172851.fuap4ennmdj473yu@linux.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, keyrings@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, Mimi Zohar <zohar@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On 6/28/2017 1:28 PM, Jarkko Sakkinen wrote:
 > On Mon, Jun 26, 2017 at 08:33:59AM -0400, Mimi Zohar wrote:
 >> On Sat, 2017-06-24 at 11:03 +0200, Jarkko Sakkinen wrote:
 >>> On Wed, Jun 21, 2017 at 04:29:35PM +0200, Roberto Sassu wrote:
 >>
 >>
 >>> To move this forward and be more constructive here's how I see it
 >>> should be done (along the lines, draft):
 >>>
 >>> int tpm_pcr_extend(u32 chip_num, int pcr_idx, unsigned int alg,
 >>> 		   const u8 *hash);

This appears to be a single algorithm extend.

TPM 2.0 permits all algorithms to be extended in one operation. 
Splitting it is likely to nearly double the extend time.

Would performance be better using the TPM pattern, a count plus 
algorithm / digest pairs?  It's TPML_DIGEST_VALUES, the input to 
TPM2_PCR_Extend.

 >>>
 >>> The paramater 'alg' is crypto ID as specified by crypto subsystem.
 >>
 >> Based on Kenneth Goldman's input, the new IMA TPM-2.0 crypto hash
 >> agile measurement list will contain the TPM crypto hash algorithm ids
 >> (TPM crypto-ID).
 >
 > Doesn't this lock you to TPM?
 >
> If you seriously want to do this, I guess it is fine by me but I'm
> just wondering why the measurement list couldn't use something with
> more loose binding to TPM.
Are you asking, "Why use the TPM algorithm ID?"  If so:

1 - The IMA measurement log is already closely linked to a TPM.

2 - Why not use the TPM algorithm IDs?  They are standardized (ISO) and 
maintained.  It's unlikely that a TPM will ever be manufactured that 
uses a digest algorithm that is not in the TCG registry.

3 - The device driver needs the TPM algorithm ID already to do the 
extend, so it seems natural to use that value everywhere.

 >>> TPM driver must have a precompiled table of mappings for crypto IDs
 >>> and TPM algorithm IDs.
 >>
 >> We could map the TPM crypto-IDs to the crypto subsystem IDs and then
 >> map them back, but is that necessary?

That's the question.  Why have two values and add the mapping?

 >>> There's absolutely no need to pass digest size like you do BTW as 
it >>> is defined by the standard.
 >>
 >> For algorithms known to the crypto subsystem, that is fine, but for
 >> the unknown TPM crypto algorithms, we would need to somehow query the
 >> TPM for the digest sizes to create the mapping.
 >>
 >> Mimi
 >
 > There's a TPM command to query TPM algorithms.

This is true - one getcap to determine the number of algorithms, then a 
pcr read, then parse the response structures and match the algorithms to 
sizes.

Alternatively, could you create a table mapping the algorithm to the 
size?  There are currently 8 approved algorithms, meaning the table is 
32 bytes, probably less code than the queries.

As for an algorithm appearing in the TPM that's not in the table, it 
takes a year or more for a new algorithm to appear.  Is that enough time 
to patch the device driver?

FYI, the 8 algorithms are:

sha1, sha256, sha384, sha512, sm3-256, sha3-256, sha3-384, sha3-512.

I am only aware of sha1, sha256, and sm3-256 being used in production 
hardware TPMs.
