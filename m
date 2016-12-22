From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [RFC 0/1] TPM2 engine support for openssl
Date: Thu, 22 Dec 2016 08:42:10 -0800
Message-ID: <1482424930.2415.35.camel@HansenPartnership.com>
References: <1482382526.2350.57.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1482382526.2350.57.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ibmtpm20tss-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

[openssl-dev cut; they're likely not interested in this]
On Wed, 2016-12-21 at 20:55 -0800, James Bottomley wrote:
> There's also another problem in that a primary asymmetric key of the 
> SPS must be provisioned every time we perform this operation (which 
> is time consuming and annoying).  I think we need to do something 
> about this under Linux, but I'll take that off the openssl list 
> because they likely won't be interested.

I talked to Microsoft about what they do.  Apparently there is an
unpublished TPM 2.0 provisioning guide which specifies how the SRK
should be handled, and a published one for the EK:

http://www.trustedcomputinggroup.org/wp-content/uploads/Credential_Profile_EK_V2.0_R14_published.pdf

the SRK template is identical to the EK one except that

userWithAuth = 1
adminWithPolicy = 0
noDA = 1
authPolicy = empty policy

The persistent handles for these two are EK: 0x81010001; SRK:
0x81000001.  Conventionally the SRK is provisioned with empty auth.

I think as part of our tpm2 take ownership, we should provision the
owner and lockout auth and create these two primary objects if they
don't already exist.

That would mean I can get rid of the primary object stuff in my tpm2
engine code and simply look for the well known handle.

James




------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today.http://sdm.link/intel
