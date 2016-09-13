From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: RFC: "Hardened" trusted keys
Date: Tue, 13 Sep 2016 09:31:29 -0400
Message-ID: <nr8v3d$md8$1@blaine.gmane.org>
References: <20160829190547.GA18827@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160829190547.GA18827-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 8/29/2016 3:05 PM, Jarkko Sakkinen wrote:
> After LSS2016 I got this idea of having hardened trusted keys for TPM2
> where the key material is never exposed to kernel. Child keys of a
> hardened trusted key would be unsealed using TPM2_EncryptDecrypt
> operation.

Beware that the TPM2_EncryptDecrypt command is optional.  I know of at 
least one TPM vendor that does not implement the command due to export 
restrictions.

Why not seal to a parent symmetric key and use TPM2_Unseal?  Unseal is 
just a restricted decryption operation.




------------------------------------------------------------------------------
