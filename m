From: Ken Goldman <kgoldman@us.ibm.com>
Subject: Re: [PATCH 1/1] add TPM2 version of create_tpm2_key
 and libtpm2.so engine
Date: Tue, 10 Jan 2017 14:38:58 -0500
Message-ID: <o53d8b$6u6$1@blaine.gmane.org>
References: <1483224485.2518.20.camel@HansenPartnership.com>
	<1483224763.2518.24.camel@HansenPartnership.com>
	<20170103231126.GE29656@obsidianresearch.com>
	<1483485776.2464.50.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <trousers-tech-bounces@lists.sourceforge.net>
In-Reply-To: <1483485776.2464.50.camel@HansenPartnership.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/trousers-tech>,
	<mailto:trousers-tech-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=trousers-tech>
List-Post: <mailto:trousers-tech@lists.sourceforge.net>
List-Help: <mailto:trousers-tech-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/trousers-tech>,
	<mailto:trousers-tech-request@lists.sourceforge.net?subject=subscribe>
Errors-To: trousers-tech-bounces@lists.sourceforge.net
To: trousers-tech@lists.sourceforge.net
Cc: tpmdd-devel@lists.sourceforge.net, openssl-dev@openssl.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 1/3/2017 6:22 PM, James Bottomley wrote:
>
> Note that google took an alternative approach and modified their TSS to
> work with a MD5-SHA1 signature:
>
> https://chromium-review.googlesource.com/#/c/420811/
>
> But this requires a modification to the TPM as well, which we can't do.

Right.  It's not a TSS issue.  Modification is futile.  It just passes 
parameters on to the TPM.  The place for this change is the TCG's TPM 
work group.



------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
